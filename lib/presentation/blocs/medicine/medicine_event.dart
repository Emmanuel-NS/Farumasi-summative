import 'package:equatable/equatable.dart';
import 'package:farumasi_patient_app/data/models/models.dart';

abstract class MedicineEvent extends Equatable {
  const MedicineEvent();

  @override
  List<Object> get props => [];
}

class LoadMedicines extends MedicineEvent {
  final String category;
  
  const LoadMedicines({this.category = 'All'});

  @override
  List<Object> get props => [category];
}

class SearchMedicines extends MedicineEvent {
  final String query;

  const SearchMedicines(this.query);

  @override
  List<Object> get props => [query];
}

class FilterMedicinesByCategory extends MedicineEvent {
  final String category;
  
  const FilterMedicinesByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class AddMedicine extends MedicineEvent {
  final Medicine medicine;
  const AddMedicine(this.medicine);
  @override
  List<Object> get props => [medicine];
}

class UpdateMedicine extends MedicineEvent {
  final Medicine medicine;
  const UpdateMedicine(this.medicine);
  @override
  List<Object> get props => [medicine];
}

class DeleteMedicine extends MedicineEvent {
  final String id;
  const DeleteMedicine(this.id);
  @override
  List<Object> get props => [id];
}
