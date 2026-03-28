import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/data/models/medicine.dart';
import 'package:farumasi_patient_app/domain/repositories/medicine_repository.dart';
import 'medicine_event.dart';
import 'medicine_state.dart';

export 'medicine_event.dart';
export 'medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository repository;
  StreamSubscription<List<Medicine>>? _subscription;

  MedicineBloc(this.repository) : super(MedicineInitial()) {
    on<LoadMedicines>(_onLoadMedicines);
    on<SearchMedicines>(_onSearchMedicines);
    on<FilterMedicinesByCategory>(_onFilterByCategory);
    on<AddMedicine>(_onAddMedicine);
    on<UpdateMedicine>(_onUpdateMedicine);
    on<DeleteMedicine>(_onDeleteMedicine);
    on<_MedicinesUpdated>(_onMedicinesUpdated);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _onLoadMedicines(LoadMedicines event, Emitter<MedicineState> emit) {
    emit(MedicineLoading());
    _subscription?.cancel();
    _subscription = repository.getMedicinesStream().listen(
      (medicines) {
        add(_MedicinesUpdated(medicines));
      },
      onError: (e) {
        add(_MedicineErrorEvent(e.toString()));
      },
    );
  }

  void _onMedicinesUpdated(_MedicinesUpdated event, Emitter<MedicineState> emit) {
    if (state is MedicineLoaded) {
      final currentState = state as MedicineLoaded;
      final filtered = _applyFilters(
        event.medicines,
        currentState.activeCategory,
        currentState.searchQuery,
      );
      emit(currentState.copyWith(
        allMedicines: event.medicines,
        medicines: filtered,
      ));
    } else {
      emit(MedicineLoaded(
        allMedicines: event.medicines,
        medicines: event.medicines,
      ));
    }
  }

  void _onSearchMedicines(SearchMedicines event, Emitter<MedicineState> emit) {
    if (state is MedicineLoaded) {
      final currentState = state as MedicineLoaded;
      final filtered = _applyFilters(
        currentState.allMedicines,
        'All', // Usually resets category on search
        event.query,
      );
      emit(currentState.copyWith(
        medicines: filtered,
        searchQuery: event.query,
        activeCategory: 'All',
      ));
    }
  }

  void _onFilterByCategory(FilterMedicinesByCategory event, Emitter<MedicineState> emit) {
    if (state is MedicineLoaded) {
      final currentState = state as MedicineLoaded;
      final filtered = _applyFilters(
        currentState.allMedicines,
        event.category,
        '', // Reset search on category change
      );
      emit(currentState.copyWith(
        medicines: filtered,
        activeCategory: event.category,
        searchQuery: '',
      ));
    }
  }

  List<Medicine> _applyFilters(List<Medicine> all, String category, String query) {
    var filtered = all;
    if (category != 'All') {
      filtered = filtered.where((m) => m.category == category).toList();
    }
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered.where((m) => m.name.toLowerCase().contains(lowerQuery)).toList();
    }
    return filtered;
  }

  Future<void> _onAddMedicine(AddMedicine event, Emitter<MedicineState> emit) async {
    try {
      await repository.addMedicine(event.medicine);
    } catch (e) {
      emit(MedicineError('Failed to add medicine: $e'));
    }
  }

  Future<void> _onUpdateMedicine(UpdateMedicine event, Emitter<MedicineState> emit) async {
    try {
      await repository.updateMedicine(event.medicine);
    } catch (e) {
      emit(MedicineError('Failed to update medicine: $e'));
    }
  }

  Future<void> _onDeleteMedicine(DeleteMedicine event, Emitter<MedicineState> emit) async {
    try {
      await repository.deleteMedicine(event.id);
    } catch (e) {
      emit(MedicineError('Failed to delete medicine: $e'));
    }
  }
}

class _MedicinesUpdated extends MedicineEvent {
  final List<Medicine> medicines;
  const _MedicinesUpdated(this.medicines);
  @override
  List<Object> get props => [medicines];
}

class _MedicineErrorEvent extends MedicineEvent {
  final String message;
  const _MedicineErrorEvent(this.message);
  @override
  List<Object> get props => [message];
}
