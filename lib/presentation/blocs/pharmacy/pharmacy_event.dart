import 'package:equatable/equatable.dart';
import 'package:farumasi_patient_app/data/models/pharmacy.dart';

abstract class PharmacyEvent extends Equatable {
  const PharmacyEvent();

  @override
  List<Object> get props => [];
}

class LoadPharmacies extends PharmacyEvent {}

class AddPharmacy extends PharmacyEvent {
  final Pharmacy pharmacy;
  const AddPharmacy(this.pharmacy);
  @override
  List<Object> get props => [pharmacy];
}

class UpdatePharmacy extends PharmacyEvent {
  final Pharmacy pharmacy;
  const UpdatePharmacy(this.pharmacy);
  @override
  List<Object> get props => [pharmacy];
}

class DeletePharmacy extends PharmacyEvent {
  final String id;
  const DeletePharmacy(this.id);
  @override
  List<Object> get props => [id];
}
