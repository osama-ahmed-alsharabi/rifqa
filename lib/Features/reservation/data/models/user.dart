class UserApp {
  final String id;
  final String name;
  final String password;

  UserApp({
    required this.id,
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
    };
  }

  factory UserApp.fromMap(Map<String, dynamic> map) {
    return UserApp(
      id: map['id'],
      name: map['name'],
      password: map['password'],
    );
  }
}
