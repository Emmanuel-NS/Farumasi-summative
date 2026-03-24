class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'User', 'Pharmacist', 'Rider', 'Admin'
  final bool isActive;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
    this.phone = '',
  });
}
