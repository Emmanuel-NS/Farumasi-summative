class Driver {
  final String id;
  final String name;
  final String phoneNumber;
  final List<double> currentCoordinates; // [lat, long]
  final bool isAvailable;

  Driver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.currentCoordinates,
    this.isAvailable = true,
  });
}
