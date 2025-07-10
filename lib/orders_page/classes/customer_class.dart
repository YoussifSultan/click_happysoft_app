class Customer {
  final int id;
  final String name;

  Customer({
    required this.id,
    required this.name,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'Customer(id: $id, name: $name)';
}
