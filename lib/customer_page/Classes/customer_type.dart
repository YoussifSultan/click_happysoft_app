class CustomerType {
  String customerType;
  int id;

  CustomerType({required this.customerType, required this.id});

  CustomerType fromjson(Map<String, dynamic> json) {
    return CustomerType(
      customerType: json['customerType'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'customerType': customerType,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'CustomerType{customerType: $customerType, id: $id}';
  }

  static List<CustomerType> get customerTypes {
    return [
      CustomerType(customerType: 'Company', id: 1),
      CustomerType(customerType: 'Individual', id: 2),
      CustomerType(customerType: 'Foriegn Individual', id: 3),
    ];
  }

  static CustomerType get company {
    return CustomerType(customerType: 'Company', id: 1);
  }

  static CustomerType get indivisual {
    return CustomerType(customerType: 'Indivisual', id: 2);
  }

  static CustomerType get foreignIndivisual {
    return CustomerType(customerType: 'Foreign Indivisual', id: 3);
  }
}
