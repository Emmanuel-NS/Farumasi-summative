import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';
import '../dummy_data.dart'; // Import dummy data

class StateService extends ChangeNotifier {
  static final StateService _instance = StateService._internal();
  factory StateService() => _instance;
  StateService._internal();

  // Auth State
  bool _isLoggedIn = false;
  String _currentUserId = "user1"; // For simulation

  // Data State
  final List<Medicine> _medicines = List.from(dummyMedicines);
  List<Medicine> get medicines => _medicines;

  final List<Pharmacy> _pharmacies = List.from(dummyPharmacies);
  List<Pharmacy> get pharmacies => _pharmacies;

  final List<HealthArticle> _healthArticles = List.from(dummyHealthArticles);
  List<HealthArticle> get healthArticles => _healthArticles;

  // Medicine CRUD
  void addMedicine(Medicine medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }

  void updateMedicine(Medicine updatedMedicine) {
    final index = _medicines.indexWhere((m) => m.id == updatedMedicine.id);
    if (index != -1) {
      _medicines[index] = updatedMedicine;
      notifyListeners();
    }
  }

  void deleteMedicine(String id) {
    _medicines.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // Pharmacy CRUD
  void addPharmacy(Pharmacy pharmacy) {
    _pharmacies.add(pharmacy);
    notifyListeners();
  }

  void updatePharmacy(Pharmacy updatedPharmacy) {
    final index = _pharmacies.indexWhere((p) => p.id == updatedPharmacy.id);
    if (index != -1) {
      _pharmacies[index] = updatedPharmacy;
      notifyListeners();
    }
  }

  void deletePharmacy(String id) {
    _pharmacies.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Health Article CRUD
  void addHealthArticle(HealthArticle article) {
    _healthArticles.add(article);
    notifyListeners();
  }

  void updateHealthArticle(HealthArticle updatedArticle) {
    final index = _healthArticles.indexWhere((a) => a.id == updatedArticle.id);
    if (index != -1) {
      _healthArticles[index] = updatedArticle;
      notifyListeners();
    }
  }

  void deleteHealthArticle(String id) {
    _healthArticles.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // Users State
  final List<User> _users = [
    User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      role: 'User',
      phone: '+250788111222',
    ),
    User(
      id: '2',
      name: 'Jane Pharm',
      email: 'jane@pharmacy.rw',
      role: 'Pharmacist',
      phone: '+250788333444',
    ),
    User(
      id: '3',
      name: 'Mike Rider',
      email: 'mike@rider.rw',
      role: 'Rider',
      phone: '+250788555666',
    ),
    User(
      id: '4',
      name: 'Admin User',
      email: AppConstants.adminEmail,
      role: 'Admin',
      phone: '+250788999000',
    ),
  ];
  List<User> get users => _users;

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  // Orders State
  final List<PrescriptionOrder> _orders = [
    PrescriptionOrder(
      id: "ORD-1001",
      patientName: "Alice M.",
      patientLocationName: "Kigali Heights",
      patientCoordinates: [-1.95, 30.09],
      date: DateTime.now().subtract(const Duration(hours: 2)),
      status: OrderStatus.pendingReview,
      items: [
        CartItem(medicine: dummyMedicines[0]),
      ], // Assuming dummyMedicines exists
      pharmacyPrice: 5000,
    ),
    PrescriptionOrder(
      id: "ORD-1002",
      patientName: "Bob K.",
      patientLocationName: "Remera, Giporoso",
      patientCoordinates: [-1.96, 30.11],
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: OrderStatus.delivered,
      items: [
        CartItem(medicine: dummyMedicines[1]),
        CartItem(medicine: dummyMedicines[2]),
      ],
      pharmacyPrice: 12500,
    ),
  ];
  List<PrescriptionOrder> get orders => _orders;

  void addOrder(PrescriptionOrder order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = status;
      notifyListeners();
    }
  }

  void deleteOrder(String id) {
    _orders.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  // Bookings
  final List<PharmacistBooking> _bookings = [];
  List<PharmacistBooking> get bookings => _bookings;

  void addBooking(PharmacistBooking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void cancelBooking(String id) {
    _bookings.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  String? _userEmail;
  String? _userName;

  // Location State
  String? _userAddress;
  String? _userCoordinates;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get userAddress => _userAddress;
  String? get userCoordinates => _userCoordinates;

  void setLocation(String address, String coordinates) {
    _userAddress = address;
    _userCoordinates = coordinates;
    notifyListeners();
  }

  // --- Consultations / Chat ---
  final List<ConsultationSession> _consultations = [
    ConsultationSession(
      id: "C-101",
      userId: "1",
      userName: "Alice M.",
      topic: "Dosage query",
      startedAt: DateTime.now().subtract(Duration(hours: 1)),
      unreadCount: 1,
      messages: [
        ChatMessage(
          id: "m1",
          text: "Hello, how often should I take Paracetamol?",
          senderId: "1",
          timestamp: DateTime.now().subtract(Duration(minutes: 58)),
        ),
      ],
    ),
    ConsultationSession(
      id: "C-102",
      userId: "2",
      userName: "Bob K.",
      topic: "Prescription verification",
      startedAt: DateTime.now().subtract(Duration(days: 1)),
      unreadCount: 0,
      messages: [
        ChatMessage(
          id: "m2",
          text: "Is my prescription ready?",
          senderId: "2",
          timestamp: DateTime.now().subtract(Duration(days: 1)),
        ),
        ChatMessage(
          id: "m3",
          text: "Yes, it is being processed.",
          senderId: "admin",
          timestamp: DateTime.now().subtract(Duration(hours: 23)),
          isMe: true,
        ),
      ],
    ),
  ];
  List<ConsultationSession> get consultations => _consultations;

  void addMessage(String sessionId, String text) {
    // This is primarily for Admin replies
    final index = _consultations.indexWhere((c) => c.id == sessionId);
    if (index != -1) {
      _consultations[index].messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          senderId: "admin",
          timestamp: DateTime.now(),
          isMe: true, // Admin is "Me" in admin view
        ),
      );
      notifyListeners();
    }
  }

  // --- User Side Consultation ---
  ConsultationSession get userConsultation {
    // Find existing session for current user or create one
    final existingIndex = _consultations.indexWhere(
      (c) => c.userId == _currentUserId,
    );
    if (existingIndex != -1) {
      return _consultations[existingIndex];
    }

    // Create new if none
    final newSession = ConsultationSession(
      id: "C-${DateTime.now().millisecondsSinceEpoch}",
      userId: _currentUserId,
      userName: _userName ?? "User",
      topic: "General Inquiry",
      startedAt: DateTime.now(),
      messages: [],
    );
    _consultations.add(newSession);
    return newSession;
  }

  void sendUserMessage(String text) {
    final session = userConsultation;
    session.messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        senderId: _currentUserId,
        timestamp: DateTime.now(),
        isMe: true, // User is "Me" in user view
      ),
    );

    // Simulate auto-reply for demo
    Future.delayed(const Duration(seconds: 2), () {
      session.messages.add(
        ChatMessage(
          id: "${DateTime.now().millisecondsSinceEpoch}_reply",
          text: "Thank you for your message. A pharmacist will reply shortly.",
          senderId: "admin",
          timestamp: DateTime.now(),
          isMe: false,
        ),
      );
      notifyListeners();
    });

    notifyListeners();
  }

  /// Suggests the user enables location services, requests permissions,
  /// and updates the state with real GPS coordinates.
  Future<void> fetchRealLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();

    // Update state with real coordinates
    // Note: To get address from coordinates, we would need 'geocoding' package.
    // For now, we update coordinates and keep a generic "Current Location" label
    // or previous address if user didn't type one.
    setLocation(
      _userAddress ?? "Current GPS Location",
      "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}",
    );
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  void login(String email, {String? name}) {
    _isLoggedIn = true;
    _userEmail = email;
    _userName = name ?? email.split('@')[0];
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;
    notifyListeners();
  }

  // Cart State
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  void addToCart(Medicine medicine, int quantity) {
    var existingIndex = _cartItems.indexWhere(
      (item) => item.medicine.id == medicine.id,
    );
    if (existingIndex >= 0) {
      final oldItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = oldItem.copyWith(
        quantity: oldItem.quantity + quantity,
      );
    } else {
      _cartItems.add(CartItem(medicine: medicine, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String medicineId) {
    _cartItems.removeWhere((item) => item.medicine.id == medicineId);
    notifyListeners();
  }

  void decrementQuantity(String medicineId) {
    var existingIndex = _cartItems.indexWhere(
      (item) => item.medicine.id == medicineId,
    );
    if (existingIndex >= 0) {
      final oldItem = _cartItems[existingIndex];
      if (oldItem.quantity > 1) {
        _cartItems[existingIndex] = oldItem.copyWith(
          quantity: oldItem.quantity - 1,
        );
      } else {
        _cartItems.removeAt(existingIndex);
      }
      notifyListeners();
    }
  }

  void incrementQuantity(String medicineId) {
    var existingIndex = _cartItems.indexWhere(
      (item) => item.medicine.id == medicineId,
    );
    if (existingIndex >= 0) {
      final oldItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = oldItem.copyWith(
        quantity: oldItem.quantity + 1,
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + item.total);
  }

  // Pharmacy Preferences
  // Using Set for O(1) lookups
  final Set<String> _preferredPharmacies = {};
  final Set<String> _blockedPharmacies = {};

  bool isPharmacyPreferred(String id) => _preferredPharmacies.contains(id);
  bool isPharmacyBlocked(String id) => _blockedPharmacies.contains(id);

  // Toggle preference: true = preferred, false = remove preference
  void setPharmacyPreferred(String id, bool isPreferred) {
    if (isPreferred) {
      _preferredPharmacies.add(id);
      _blockedPharmacies.remove(id); // Can't be both
    } else {
      _preferredPharmacies.remove(id);
    }
    notifyListeners();
  }

  // Toggle block: true = blocked, false = unblocked (allowed)
  void setPharmacyBlocked(String id, bool isBlocked) {
    if (isBlocked) {
      _blockedPharmacies.add(id);
      _preferredPharmacies.remove(id); // Can't be both
    } else {
      _blockedPharmacies.remove(id);
    }
    notifyListeners();
  }
}
