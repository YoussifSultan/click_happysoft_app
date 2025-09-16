import 'package:click_happysoft_app/RVrequest_page/Classes/paymentmethods.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardSqlManager {
  static Future<int> getNoCustomers(bool isapproved, int salesmanID) async {
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
    int noCustomers = jsonDecode(response.body)[0]["count(*)"];
    return noCustomers;
  }

  static Future<int> getNoOrders(bool isapproved, int salesmanID) async {
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
    int noOrders = jsonDecode(response.body)[0]["count(*)"];
    return noOrders;
  }

  static Future<Map<String, double>> getBalance(
      int salesmanID, PaymentMethod paymentmethod) async {
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
    rv.Currency ,SUM(rv.Amount) AS Amount
FROM
    ReceiptVoucher rv
        LEFT JOIN
    salesman s ON s.salesman_id = rv.Salesman_ID
WHERE
    s.salesman_id = $salesmanID and rv.is_Deposited = 0 and rv.Payment_Method = ${paymentmethod.id}
GROUP BY s.salesman_id , rv.Currency'''
      }),
    );
    List<dynamic> balanceList = jsonDecode(response.body);
    Map<String, double> balance = {};
    for (var item in balanceList) {
      balance[item['Currency']] = item['Amount']?.toDouble() ?? 0.0;
    }
    return balance;
  }
}
