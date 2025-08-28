import 'package:click_happysoft_app/customer_page/Viewmodels/customerListItem.dart';
import 'package:click_happysoft_app/customer_page/Classes/customer_class.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class CustomerSqlManager {
  /// save new customer to the database
  /// Returns the HTTP response from the server
  /// You can check the response status code and body for success or failure
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
INSERT INTO customers (salesman_ID, Arabic_Name, English_Name, Category, Customer_Type, Mobile, Fax_Number, Phone, Email, Website, Address, Shipping_Address, National_ID_Number, approval_status) 
VALUES (${customer.salesmanID}, '${customer.arabicName}', '${customer.englishName}', '${customer.category}', ${customer.customerType.id}, '${customer.mobile}', '${customer.faxNumber}', '${customer.phone}', '${customer.email}', '${customer.website}', '${customer.address}', '${customer.shippingAddress}', '${customer.nationalIdNumber}', ${customer.isValid ? 1 : 0});
''',
      }),
    );
    return response;
  }

  static Future<List<CustomerListItem>> fetchAllCustomers(
      int salesmanID) async {
    final url = Uri.parse('https://restapi-production-e4e5.up.railway.app/get');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
SELECT 
    Customer_ID, English_Name, Customer_Type, Mobile
FROM
    customers
WHERE
    salesman_ID = 6
''',
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List.generate(data.length, (i) {
        return CustomerListItem.fromJson(data[i]);
      });
    } else {
      return Future.error('Failed to load data');
    }
  }
}
