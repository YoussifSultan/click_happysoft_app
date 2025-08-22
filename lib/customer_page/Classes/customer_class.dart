import 'package:click_happysoft_app/customer_page/Classes/customer_type.dart';

class Customer {
  int customerID;
  int salesmanID;
  String arabicName;
  String englishName;
  String category;
  CustomerType customerType; // Company / Individual / Foreign Individual
  String? mobile;
  String? faxNumber;
  String? phone;
  String? email;
  String? website;
  String? address;
  String? shippingAddress;
  String? nationalIdNumber;
  bool isValid;

  Customer({
    required this.customerID,
    required this.salesmanID,
    required this.arabicName,
    required this.englishName,
    required this.category,
    required this.customerType,
    this.mobile,
    this.faxNumber,
    this.phone,
    this.email,
    this.website,
    this.address,
    this.shippingAddress,
    this.nationalIdNumber,
    this.isValid = false,
  });

  /// Create a Customer from JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerID: json['Customer_ID'] ?? 0,
      salesmanID: json['salesman_ID'] ?? 0,
      arabicName: json['Arabic_Name'] ?? '',
      englishName: json['English_Name'] ?? '',
      category: json['Category'] ?? '',
      customerType: CustomerType.customerTypes
          .firstWhere((c) => c.id == json['Customer_Type']),
      mobile: json['Mobile'] ?? '',
      faxNumber: json['Fax_Number'] ?? '',
      phone: json['Phone'] ?? '',
      email: json['Email'] ?? '',
      website: json['Website'] ?? '',
      address: json['Address'] ?? '',
      shippingAddress: json['Shipping_Address'] ?? '',
      nationalIdNumber: json['National_ID_Number'] ?? '',
      isValid: json['isValid'] == 1 ? true : false,
    );
  }

  /// Convert Customer to JSON
  Map<String, dynamic> toJson() {
    return {
      'Customer_ID': customerID,
      'salesman_ID': salesmanID,
      'Arabic_Name': arabicName,
      'English_Name': englishName,
      'Category': category,
      'Customer_Type': customerType.id,
      'Mobile': mobile,
      'Fax_Number': faxNumber,
      'Phone': phone,
      'Email': email,
      'Website': website,
      'Address': address,
      'Shipping_Address': shippingAddress,
      'National_ID_Number': nationalIdNumber,
      'isValid': isValid,
    };
  }

  @override
  String toString() {
    return 'Customer(customerID: $customerID, salesmanID: $salesmanID, '
        'arabicName: $arabicName, englishName: $englishName, '
        'category: $category, customerType: $customerType, '
        'mobile: $mobile, faxNumber: $faxNumber, phone: $phone, '
        'email: $email, website: $website, address: $address, '
        'shippingAddress: $shippingAddress, nationalIdNumber: $nationalIdNumber, '
        'isValid: $isValid)';
  }
}
