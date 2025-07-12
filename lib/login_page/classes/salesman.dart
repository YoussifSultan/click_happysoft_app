class Salesman {
  final int id;
  final String name;
  final String email;
  final String password; // Note: Should be hashed/stored securely in real apps

  Salesman({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      id: json['salesman_id'],
      name: json['salesman_name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salesman_id': id,
      'salesman_name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() =>
      'Salesman(id: $id, name: $name, email: $email , password: $password)';
}
