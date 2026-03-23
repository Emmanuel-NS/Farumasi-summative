import 'package:equatable/equatable.dart';

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
