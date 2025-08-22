import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class DashboardSqlManager {
  static Future<Response> getNoCustomers(
      bool isapproved, int salesmanID) async {
    final url = Uri.parse('https://restapi-production-e4e5.up.railway.app/get');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
Select count(*)
from customers
where customers.approval_status = $isapproved and customers.salesman_ID =$salesmanID''',
      }),
    );
    return response;
  }

  static Future<Response> getNoOrders(bool isapproved, int salesmanID) async {
    final url = Uri.parse('https://restapi-production-e4e5.up.railway.app/get');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query': '''
Select count(*)
from orders
where orders.approval_status = $isapproved and orders.salesman_ID =$salesmanID''',
      }),
    );
    return response;
  }
}
