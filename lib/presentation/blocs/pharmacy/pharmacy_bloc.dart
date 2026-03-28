import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/data/repositories/pharmacy_repository_impl.dart';
import 'package:farumasi_patient_app/data/models/pharmacy.dart';
import 'pharmacy_event.dart';
import 'pharmacy_state.dart';

export 'pharmacy_event.dart';
export 'pharmacy_state.dart';

class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {
  final PharmacyRepository repository;
  StreamSubscription<List<Pharmacy>>? _subscription;

  PharmacyBloc({required this.repository}) : super(PharmacyInitial()) {
    on<LoadPharmacies>(_onLoadPharmacies);
    on<AddPharmacy>(_onAddPharmacy);
    on<UpdatePharmacy>(_onUpdatePharmacy);
    on<DeletePharmacy>(_onDeletePharmacy);
    on<_PharmaciesUpdated>(_onPharmaciesUpdated);
    on<_PharmacyErrorEvent>(_onPharmacyError);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _onLoadPharmacies(LoadPharmacies event, Emitter<PharmacyState> emit) {
    emit(PharmacyLoading());
    _subscription?.cancel();
    _subscription = repository.getPharmaciesStream().listen(
      (pharmacies) {
        add(_PharmaciesUpdated(pharmacies));
      },
      onError: (e) {
        add(_PharmacyErrorEvent(e.toString()));
      },
    );
  }

  void _onPharmaciesUpdated(_PharmaciesUpdated event, Emitter<PharmacyState> emit) {
    emit(PharmacyLoaded(event.pharmacies));
  }

  void _onPharmacyError(_PharmacyErrorEvent event, Emitter<PharmacyState> emit) {
    emit(PharmacyError('Failed to load pharmacies: ${event.message}'));
  }

  Future<void> _onAddPharmacy(AddPharmacy event, Emitter<PharmacyState> emit) async {
    try {
      await repository.addPharmacy(event.pharmacy);
    } catch (e) {
      emit(PharmacyError('Failed to add pharmacy: $e'));
    }
  }

  Future<void> _onUpdatePharmacy(UpdatePharmacy event, Emitter<PharmacyState> emit) async {
    try {
      await repository.updatePharmacy(event.pharmacy);
    } catch (e) {
      emit(PharmacyError('Failed to update pharmacy: $e'));
    }
  }

  Future<void> _onDeletePharmacy(DeletePharmacy event, Emitter<PharmacyState> emit) async {
    try {
      await repository.deletePharmacy(event.id);
    } catch (e) {
      emit(PharmacyError('Failed to delete pharmacy: $e'));
    }
  }
}

class _PharmaciesUpdated extends PharmacyEvent {
  final List<Pharmacy> pharmacies;
  const _PharmaciesUpdated(this.pharmacies);
  @override
  List<Object> get props => [pharmacies];
}

class _PharmacyErrorEvent extends PharmacyEvent {
  final String message;
  const _PharmacyErrorEvent(this.message);
  @override
  List<Object> get props => [message];
}
