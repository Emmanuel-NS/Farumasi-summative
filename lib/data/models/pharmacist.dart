enum PharmacistStatus { available, busy, offline }

class Pharmacist {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final String organization; // Added organization
  final PharmacistStatus status; // Added status
  final int yearsExperience;

  Pharmacist({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    this.organization = 'HealthPlus Pharmacy', // Default
    this.status = PharmacistStatus.available, // Default
    this.yearsExperience = 5,
  });
}
