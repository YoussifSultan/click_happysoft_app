import 'package:click_happysoft_app/customer_page/Classes/customer_class.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class CustomerSqlManager {
  /// Saves a new order to the database.
  /// Returns the ressponse code from the server.'
  /// order should be an instance of Order class.
  static Future<Response> addNewCustomer(Customer customer) async {
    final url =
        Uri.parse('https://restapi-production-e4e5.up.railway.app/insert');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
INSERT INTO customers (Customer_ID, Arabic_Name, English_Name, Category, Customer_Type, Mobile, Fax_Number, Phone, Email, Website, Address, Shipping_Address, National_ID_Number,Is_Valid)
VALUES (0, N'${customer.arabicName}', '${customer.englishName}', '${customer.category}', '${customer.customerType.id}', '${customer.mobile}', '${customer.faxNumber}', '${customer.phone}', '${customer.email}', '${customer.website}', '${customer.address}', '${customer.shippingAddress}', '${customer.nationalIdNumber}', ${customer.isValid ? 1 : 0});
''',
      }),
    );
    return response;
  }
}
