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
}
