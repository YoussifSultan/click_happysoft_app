import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/classes/customer_class.dart';
import 'package:click_happysoft_app/orders_page/classes/product_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderSqlManager {
  /// Fetches orders from the database and returns a list of Order objects.
  static Future<List<OrderDetailsVM>> fetchAllOrders() async {
    final url = Uri.parse('https://restapi-production-b83a.up.railway.app/get');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    p.product_name,
    s.salesman_name,
    o.qty
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
JOIN salesman s ON o.salesman_id = s.salesman_id
where o.salesman_id = 1
ORDER BY o.order_date DESC
''',
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List.generate(data.length, (i) {
        return OrderDetailsVM.fromJson(data[i]);
      });
    } else {
      return Future.error('Failed to load data');
    }
  }

  /// fetch all customers from the database
  static Future<List<Customer>> fetchAllCustomers() async {
    final url = Uri.parse('https://restapi-production-b83a.up.railway.app/get');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
Select * from railway.customers
''',
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List.generate(data.length, (i) {
        return Customer.fromJson(data[i]);
      });
    } else {
      return Future.error('Failed to load data');
    }
  }

  /// fetch all products from the database
  static Future<List<Product>> fetchAllProducts() async {
    final url = Uri.parse('https://restapi-production-b83a.up.railway.app/get');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
Select * from railway.products''',
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List.generate(data.length, (i) {
        return Product.fromJson(data[i]);
      });
    } else {
      return Future.error('Failed to load data');
    }
  }
}
