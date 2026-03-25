import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/domain/repositories/medicine_repository.dart';
import 'medicine_event.dart';
import 'medicine_state.dart';

export 'medicine_event.dart';
export 'medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository repository;

  MedicineBloc(this.repository) : super(MedicineInitial()) {
    on<LoadMedicines>(_onLoadMedicines);
    on<SearchMedicines>(_onSearchMedicines);
    on<FilterMedicinesByCategory>(_onFilterByCategory);
    on<AddMedicine>(_onAddMedicine);
    on<UpdateMedicine>(_onUpdateMedicine);
    on<DeleteMedicine>(_onDeleteMedicine);
  }

  Future<void> _onLoadMedicines(
    LoadMedicines event,
    Emitter<MedicineState> emit,
  ) async {
    emit(MedicineLoading());
    try {
      final medicines = await repository.getMedicinesByCategory(event.category);
      // Also potentially handle initial search query if needed, but for now just load
      emit(
        MedicineLoaded(medicines: medicines, activeCategory: event.category),
      );
    } catch (e) {
      emit(MedicineError('Failed to load medicines: ${e.toString()}'));
    }
  }

  Future<void> _onSearchMedicines(
    SearchMedicines event,
    Emitter<MedicineState> emit,
  ) async {
    // If we're already loaded, we want to stay loaded but filter.
    // However, repository search is async.
    emit(MedicineLoading());
    try {
      final medicines = await repository.searchMedicines(event.query);
      emit(
        MedicineLoaded(
          medicines: medicines,
          searchQuery: event.query,
          activeCategory: 'All', // Reset category on search usually
        ),
      );
    } catch (e) {
      emit(MedicineError('Search failed: $e'));
    }
  }

  Future<void> _onFilterByCategory(
    FilterMedicinesByCategory event,
    Emitter<MedicineState> emit,
  ) async {
    emit(MedicineLoading());
    try {
      final medicines = await repository.getMedicinesByCategory(event.category);
      emit(
        MedicineLoaded(medicines: medicines, activeCategory: event.category),
      );
    } catch (e) {
      emit(MedicineError('Failed to filter medicines: $e'));
    }
  }

  Future<void> _onAddMedicine(
    AddMedicine event,
    Emitter<MedicineState> emit,
  ) async {
    try {
      await repository.addMedicine(event.medicine);
      add(const LoadMedicines());
    } catch (e) {
      emit(MedicineError('Failed to add medicine: $e'));
    }
  }

  Future<void> _onUpdateMedicine(
    UpdateMedicine event,
    Emitter<MedicineState> emit,
  ) async {
    try {
      await repository.updateMedicine(event.medicine);
      add(const LoadMedicines());
    } catch (e) {
      emit(MedicineError('Failed to update medicine: $e'));
    }
  }

  Future<void> _onDeleteMedicine(
    DeleteMedicine event,
    Emitter<MedicineState> emit,
  ) async {
    try {
      await repository.deleteMedicine(event.id);
      add(const LoadMedicines());
    } catch (e) {
      emit(MedicineError('Failed to delete medicine: $e'));
    }
  }
}
