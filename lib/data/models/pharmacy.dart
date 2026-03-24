class Pharmacy {
  final String id;
  final String name;
  final String locationName;
  final List<double> coordinates; // [lat, long]
  final List<String> supportedInsurances;
  final bool isOpen;
  final String imageUrl;
  final String province;
  final String district;
  final String sector;
  final String cell;

  Pharmacy({
    required this.id,
    required this.name,
    required this.locationName,
    required this.coordinates,
    required this.supportedInsurances,
    this.isOpen = true,
    this.imageUrl = 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?q=80&w=2938&auto=format&fit=crop', // Default image
    this.province = 'Kigali City',
    this.district = 'Nyarugenge',
    this.sector = 'Nyarugenge',
    this.cell = 'Kiyovu',
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json, String id) {
    return Pharmacy(
      id: id,
      name: json['name'] ?? '',
      locationName: json['locationName'] ?? '',
      coordinates: List<double>.from(json['coordinates'] ?? []),
      supportedInsurances: List<String>.from(json['supportedInsurances'] ?? []),
      isOpen: json['isOpen'] ?? true,
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?q=80&w=2938&auto=format&fit=crop',
      province: json['province'] ?? 'Kigali City',
      district: json['district'] ?? 'Nyarugenge',
      sector: json['sector'] ?? 'Nyarugenge',
      cell: json['cell'] ?? 'Kiyovu',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'locationName': locationName,
      'coordinates': coordinates,
      'supportedInsurances': supportedInsurances,
      'isOpen': isOpen,
      'imageUrl': imageUrl,
      'province': province,
      'district': district,
      'sector': sector,
      'cell': cell,
    };
  }
}
