import 'package:click_happysoft_app/orders_page/Viewmodels/customerVM.dart';
import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/classes/orders_class.dart';
import 'package:click_happysoft_app/orders_page/classes/product_class.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class OrderSqlManager {
  /// Fetches orders from the database and returns a list of Order objects.
  static Future<List<OrderDetailsVM>> fetchAllOrders(int salesmanID) async {
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
    o.order_id,
    o.order_date,
    o.product_id,
    o.customer_id,
    o.salesman_id,
    c.customer_name,
    p.product_name,
    s.salesman_name,
    o.qty
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
JOIN salesman s ON o.salesman_id = s.salesman_id
where o.salesman_id = $salesmanID 
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
  static Future<List<CustomerVM>> fetchAllCustomers() async {
    final url = Uri.parse('https://restapi-production-e4e5.up.railway.app/get');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
SELECT Customer_ID,English_Name FROM railway.customers;	''',
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List.generate(data.length, (i) {
        return CustomerVM.fromJson(data[i]);
      });
    } else {
      return Future.error('Failed to load data');
    }
  }

  /// fetch all products from the database
  static Future<List<Product>> fetchAllProducts() async {
    final url = Uri.parse('https://restapi-production-e4e5.up.railway.app/get');
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

  /// Saves a new order to the database.
  /// Returns the ressponse code from the server.'
  /// order should be an instance of Order class.
  static Future<Response> addnewOrder(Order order) async {
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
INSERT INTO orders (product_id, customer_id, salesman_id, qty, order_date)
VALUES (${order.productId}, ${order.customerId}, ${order.salesmanId}, ${order.qty}, '${order.date.toIso8601String()}');
''',
      }),
    );
    return response;
  }

  /// Edits the existing order in the database.
  /// Returns the response code from the server.
  static Future<int> editOrder(Order newOrder) async {
    final url =
        Uri.parse('https://restapi-production-e4e5.up.railway.app/update');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
UPDATE orders
SET
  product_id = ${newOrder.productId},
  customer_id = ${newOrder.customerId},
  salesman_id = ${newOrder.salesmanId},
  qty = ${newOrder.qty},
  order_date = '${newOrder.date.toIso8601String()}'
WHERE order_id = ${newOrder.id};
''',
      }),
    );
    if (response.statusCode == 200) {
      return 200; // Assuming 200 is the success code
    } else {
      return response.statusCode;
    }
  }

  /// Deletes an order from the database.
  /// Returns the response code from the server.
  static Future<int> deleteOrder(int orderID) async {
    final url =
        Uri.parse('https://restapi-production-e4e5.up.railway.app/delete');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
DELETE FROM orders
WHERE order_id = $orderID;''',
      }),
    );
    if (response.statusCode == 200) {
      return 200; // Assuming 200 is the success code
    } else {
      return response.statusCode;
    }
  }
}
