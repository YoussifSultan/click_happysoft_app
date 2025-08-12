class CustomerVM {
  final int id;
  final String name;

  CustomerVM({
    required this.id,
    required this.name,
  });

  factory CustomerVM.fromJson(Map<String, dynamic> json) {
    return CustomerVM(
      id: json['Customer_ID'],
      name: json['English_Name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Customer_ID': id,
      'English_Name': name,
    };
  }
}
