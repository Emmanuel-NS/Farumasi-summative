import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/data/repositories/pharmacy_repository_impl.dart';
import 'pharmacy_event.dart';
import 'pharmacy_state.dart';

export 'pharmacy_event.dart';
export 'pharmacy_state.dart';

class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {
  final PharmacyRepository repository;

  PharmacyBloc({required this.repository}) : super(PharmacyInitial()) {
    on<LoadPharmacies>(_onLoadPharmacies);
    on<AddPharmacy>(_onAddPharmacy);
    on<UpdatePharmacy>(_onUpdatePharmacy);
    on<DeletePharmacy>(_onDeletePharmacy);
  }

  Future<void> _onLoadPharmacies(
    LoadPharmacies event,
    Emitter<PharmacyState> emit,
  ) async {
    emit(PharmacyLoading());
    try {
      final pharmacies = await repository.getPharmacies();
      emit(PharmacyLoaded(pharmacies));
    } catch (e) {
      emit(PharmacyError('Failed to load pharmacies: $e'));
    }
  }

  Future<void> _onAddPharmacy(
    AddPharmacy event,
    Emitter<PharmacyState> emit,
  ) async {
    try {
      await repository.addPharmacy(event.pharmacy);
      add(LoadPharmacies());
    } catch (e) {
      emit(PharmacyError('Failed to add pharmacy: $e'));
    }
  }

  Future<void> _onUpdatePharmacy(
    UpdatePharmacy event,
    Emitter<PharmacyState> emit,
  ) async {
    try {
      await repository.updatePharmacy(event.pharmacy);
      add(LoadPharmacies());
    } catch (e) {
      emit(PharmacyError('Failed to update pharmacy: $e'));
    }
  }

  Future<void> _onDeletePharmacy(
    DeletePharmacy event,
    Emitter<PharmacyState> emit,
  ) async {
    try {
      await repository.deletePharmacy(event.id);
      add(LoadPharmacies());
    } catch (e) {
      emit(PharmacyError('Failed to delete pharmacy: $e'));
    }
  }
}
