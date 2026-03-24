class PharmacistBooking {
  final String id;
  final String pharmacistId;
  final String pharmacistName;
  final String patientName; // Added for Pharmacist side
  final String type; // e.g. "General Consultation"
  final DateTime date;
  final String time;
  final String notes;
  final String status; // "Confirmed", "Pending", "Completed"

  PharmacistBooking({
    required this.id,
    required this.pharmacistId,
    required this.pharmacistName,
    this.patientName = "Unknown Patient",
    this.type = "General Consultation",
    required this.date,
    required this.time,
    required this.notes,
    this.status = "Pending",
  });
}
