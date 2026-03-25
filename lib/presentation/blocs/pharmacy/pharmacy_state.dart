import 'package:equatable/equatable.dart';
import 'package:farumasi_patient_app/data/models/pharmacy.dart';

abstract class PharmacyState extends Equatable {
  const PharmacyState();

  @override
  List<Object> get props => [];
}

class PharmacyInitial extends PharmacyState {}

class PharmacyLoading extends PharmacyState {}

class PharmacyLoaded extends PharmacyState {
  final List<Pharmacy> pharmacies;

  const PharmacyLoaded(this.pharmacies);

  @override
  List<Object> get props => [pharmacies];
}

class PharmacyError extends PharmacyState {
  final String message;
  const PharmacyError(this.message);
  @override
  List<Object> get props => [message];
}
