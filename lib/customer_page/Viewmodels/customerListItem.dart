import 'package:click_happysoft_app/customer_page/Classes/customer_type.dart';

class CustomerListItem {
  int id;
  String name;
  String mobile;
  CustomerType customerType;

  CustomerListItem(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.customerType});

  factory CustomerListItem.fromJson(Map<String, dynamic> map) {
    return CustomerListItem(
      id: map['Customer_ID'] ?? 0,
      name: map['English_Name'] ?? '',
      customerType: CustomerType.customerTypes
          .firstWhere((c) => c.id == map['Customer_Type']),
      mobile: map['Mobile'] ?? '',
    );
  }
}
