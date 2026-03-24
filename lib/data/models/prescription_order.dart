import 'order_status.dart';
import 'cart_item.dart';

class PrescriptionOrder {
  final String id;
  final String patientName;
  final String patientLocationName; // Text address
  final List<double> patientCoordinates; // [lat, long]
  final String? prescriptionImageUrl;
  final DateTime date;
  OrderStatus status;
  List<CartItem> items;
  double pharmacyPrice; // Price from pharmacy
  double deliveryFee;
  double get totalPrice => pharmacyPrice + deliveryFee;
  
  String? assignedPharmacyId;
  String? assignedPharmacyName;
  List<double>? pharmacyCoordinates;

  String? assignedDriverId;
  String? assignedDriverName;
  List<double>? driverCoordinates;

  String? insuranceProvider;

  // --- Audit Trail / Full History Fields ---
  String? reviewedBy;
  DateTime? reviewedAt;
  
  // acceptedAt corresponds to status findingPharmacy -> pharmacyAccepted
  DateTime? acceptedAt; 

  String? paymentId;
  DateTime? paidAt;
  
  DateTime? shippedAt;
  DateTime? completedAt;
  
  String? cancelledBy;
  DateTime? cancelledAt;
  String? cancellationReason;

  PrescriptionOrder({
    required this.id,
    required this.patientName,
    required this.patientLocationName,
    required this.patientCoordinates,
    this.prescriptionImageUrl,
    required this.date,
    this.status = OrderStatus.pendingReview,
    this.items = const [],
    this.pharmacyPrice = 0.0,
    this.deliveryFee = 1500.0,
    this.assignedPharmacyId,
    this.assignedPharmacyName,
    this.pharmacyCoordinates,
    this.assignedDriverId,
    this.assignedDriverName,
    this.driverCoordinates,
    this.insuranceProvider,
    this.reviewedBy,
    this.reviewedAt,
    this.acceptedAt,
    this.paymentId,
    this.paidAt,
    this.shippedAt,
    this.completedAt,
    this.cancelledBy,
    this.cancelledAt,
    this.cancellationReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'patientLocationName': patientLocationName,
      'patientCoordinates': patientCoordinates,
      'prescriptionImageUrl': prescriptionImageUrl,
      'date': date.toIso8601String(),
      'status': status.name,
      'items': items.map((e) => e.toJson()).toList(),
      'pharmacyPrice': pharmacyPrice,
      'deliveryFee': deliveryFee,
      'assignedPharmacyId': assignedPharmacyId,
      'assignedPharmacyName': assignedPharmacyName,
      'pharmacyCoordinates': pharmacyCoordinates,
      'assignedDriverId': assignedDriverId,
      'assignedDriverName': assignedDriverName,
      'driverCoordinates': driverCoordinates,
      'insuranceProvider': insuranceProvider,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'paymentId': paymentId,
      'paidAt': paidAt?.toIso8601String(),
      'shippedAt': shippedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'cancelledBy': cancelledBy,
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
    };
  }

  factory PrescriptionOrder.fromJson(Map<String, dynamic> json) {
    return PrescriptionOrder(
      id: json['id'] as String? ?? '',
      patientName: json['patientName'] as String? ?? 'Unknown Patient',
      patientLocationName: json['patientLocationName'] as String? ?? 'Unknown Location',
      patientCoordinates: (json['patientCoordinates'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [0.0, 0.0],
      prescriptionImageUrl: json['prescriptionImageUrl'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
      status: json['status'] != null ? OrderStatus.values.byName(json['status'] as String) : OrderStatus.pendingReview,
      items: (json['items'] as List<dynamic>?)?.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      pharmacyPrice: (json['pharmacyPrice'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 1500.0,
      assignedPharmacyId: json['assignedPharmacyId'] as String?,
      assignedPharmacyName: json['assignedPharmacyName'] as String?,
      pharmacyCoordinates: (json['pharmacyCoordinates'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList(),
      assignedDriverId: json['assignedDriverId'] as String?,
      assignedDriverName: json['assignedDriverName'] as String?,
      driverCoordinates: (json['driverCoordinates'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList(),
      insuranceProvider: json['insuranceProvider'] as String?,
      reviewedBy: json['reviewedBy'] as String?,
      reviewedAt: json['reviewedAt'] != null ? DateTime.parse(json['reviewedAt'] as String) : null,
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt'] as String) : null,
      paymentId: json['paymentId'] as String?,
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt'] as String) : null,
      shippedAt: json['shippedAt'] != null ? DateTime.parse(json['shippedAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      cancelledBy: json['cancelledBy'] as String?,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt'] as String) : null,
      cancellationReason: json['cancellationReason'] as String?,
    );
  }
}

