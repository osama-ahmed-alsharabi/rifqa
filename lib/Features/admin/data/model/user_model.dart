class UserModel {
  final String id;
  final String name;
  final String phone;
  final int age;
  final String cardInfo;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    required this.cardInfo,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      phone: json['phone_number'] ?? 'No Phone',
      age: json['age'] ?? 0,
      cardInfo: json['nationality'] ?? 'No Card Info',
      isActive: json['is_active'] ?? true,
    );
  }
}
