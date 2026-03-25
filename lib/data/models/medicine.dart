import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String? subCategory;
  final bool requiresPrescription;
  final double rating;
  final bool isPopular;
  final String dosage;
  final String sideEffects;
  final String manufacturer;
  final List<String> keywords;
  final double? maxPrice;
  final String? expiryDate;

  final List<String> availableAtPharmacyIds;
  final List<String> additionalCategories;
  final List<String> additionalSubCategories;

  final String? doseMorning;
  final String? doseAfternoon;
  final String? doseEvening;
  final String? doseTimeInterval;

  List<String> get allCategories =>
      {category, ...additionalCategories}.toList();
  List<String> get allSubCategories => {
    (subCategory ?? ""),
    ...additionalSubCategories,
  }.where((s) => s.isNotEmpty).toList();

  const Medicine({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.subCategory,
    this.requiresPrescription = false,
    this.rating = 4.5,
    this.isPopular = false,
    this.dosage = 'Take as directed by physician.',
    this.sideEffects = 'Consult a doctor if adverse reactions occur.',
    this.manufacturer = 'Generic Pharm Co.',
    this.keywords = const [],
    this.maxPrice,
    this.expiryDate,
    this.additionalCategories = const [],
    this.additionalSubCategories = const [],
    this.doseMorning,
    this.doseAfternoon,
    this.doseEvening,
    this.doseTimeInterval,
    this.availableAtPharmacyIds = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    category,
    subCategory,
    requiresPrescription,
    rating,
    isPopular,
    dosage,
    sideEffects,
    manufacturer,
    keywords,
    maxPrice,
    expiryDate,
    availableAtPharmacyIds,
    additionalCategories,
    additionalSubCategories,
    doseMorning,
    doseAfternoon,
    doseEvening,
    doseTimeInterval,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'subCategory': subCategory,
      'requiresPrescription': requiresPrescription,
      'rating': rating,
      'isPopular': isPopular,
      'dosage': dosage,
      'sideEffects': sideEffects,
      'manufacturer': manufacturer,
      'keywords': keywords,
      'maxPrice': maxPrice,
      'expiryDate': expiryDate,
      'availableAtPharmacyIds': availableAtPharmacyIds,
      'additionalCategories': additionalCategories,
      'additionalSubCategories': additionalSubCategories,
      'doseMorning': doseMorning,
      'doseAfternoon': doseAfternoon,
      'doseEvening': doseEvening,
      'doseTimeInterval': doseTimeInterval,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed',
      description: json['description'] as String? ?? 'No description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      subCategory: json['subCategory'] as String?,
      requiresPrescription: json['requiresPrescription'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isPopular: json['isPopular'] as bool? ?? false,
      dosage: json['dosage'] as String? ?? 'Take as directed by physician.',
      sideEffects:
          json['sideEffects'] as String? ??
          'Consult a doctor if adverse reactions occur.',
      manufacturer: json['manufacturer'] as String? ?? 'Generic Pharm Co.',
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      expiryDate: json['expiryDate'] as String?,
      availableAtPharmacyIds:
          (json['availableAtPharmacyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      additionalCategories:
          (json['additionalCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      additionalSubCategories:
          (json['additionalSubCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      doseMorning: json['doseMorning'] as String?,
      doseAfternoon: json['doseAfternoon'] as String?,
      doseEvening: json['doseEvening'] as String?,
      doseTimeInterval: json['doseTimeInterval'] as String?,
    );
  }
}
