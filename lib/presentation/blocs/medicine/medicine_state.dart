import 'package:equatable/equatable.dart';
import 'package:farumasi_patient_app/data/models/models.dart';

abstract class MedicineState extends Equatable {
  const MedicineState();

  @override
  List<Object> get props => [];
}

class MedicineInitial extends MedicineState {}

class MedicineLoading extends MedicineState {}

class MedicineLoaded extends MedicineState {
  final List<Medicine> medicines;
  final String activeCategory;
  final String searchQuery;

  const MedicineLoaded({
    required this.medicines,
    this.activeCategory = 'All',
    this.searchQuery = '',
  });

  MedicineLoaded copyWith({
    List<Medicine>? medicines,
    String? activeCategory,
    String? searchQuery,
  }) {
    return MedicineLoaded(
      medicines: medicines ?? this.medicines,
      activeCategory: activeCategory ?? this.activeCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [medicines, activeCategory, searchQuery];
}

class MedicineError extends MedicineState {
  final String message;

  const MedicineError(this.message);

  @override
  List<Object> get props => [message];
}
