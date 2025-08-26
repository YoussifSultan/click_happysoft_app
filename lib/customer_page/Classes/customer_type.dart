class CustomerType {
  final String customerType;
  final int id;

  const CustomerType({required this.customerType, required this.id});

  factory CustomerType.fromJson(Map<String, dynamic> json) {
    return CustomerType(
      customerType: json['customerType'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerType': customerType,
      'id': id,
    };
  }

  @override
  String toString() => 'CustomerType(id: $id, customerType: $customerType)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerType &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Static constants
  static const List<CustomerType> customerTypes = [
    CustomerType(customerType: 'Company', id: 1),
    CustomerType(customerType: 'Individual', id: 2),
    CustomerType(customerType: 'Foreign Individual', id: 3),
  ];

  static const CustomerType company =
      CustomerType(customerType: 'Company', id: 1);
  static const CustomerType individual =
      CustomerType(customerType: 'Individual', id: 2);
  static const CustomerType foreignIndividual =
      CustomerType(customerType: 'Foreign Individual', id: 3);
}
