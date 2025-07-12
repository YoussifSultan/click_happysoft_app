class Customer {
  final int id;
  final String name;

  Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['customer_id'],
      name: json['customer_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': id,
      'customer_name': name,
    };
  }

  @override
  String toString() => 'Customer(id: $id, name: $name)';
}
