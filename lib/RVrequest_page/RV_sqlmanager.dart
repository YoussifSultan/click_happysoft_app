import 'package:click_happysoft_app/RVrequest_page/Classes/paymentmethods.dart';
import 'package:click_happysoft_app/RVrequest_page/Classes/requestvoucher.dart';
import 'package:click_happysoft_app/RVrequest_page/Viewmodels/rv_requests_listItem.dart';
import 'package:click_happysoft_app/orders_page/Viewmodels/customerVM.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RvSqlmanager {
  /// fetch all customers from the database
  static Future<List<CustomerVM>> fetchAllCustomers(
      {bool isApproved = true}) async {
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
    Customer_ID, English_Name
FROM
    railway.customers
WHERE
    approval_status =  ${isApproved ? 1 : 0}
    ''',
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

  ///
  static Future<http.Response> addnewRVrequest(
      ReceiptVoucher receiptVoucher) async {
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
INSERT INTO ReceiptVoucher 
  ( Salesman_ID, Customer_ID, Payment_Method, Voucher_Date, Reference_No, Amount, Currency, Description, approval_status, Created_At) 
VALUES 
  ( ${receiptVoucher.salesmanId}, ${receiptVoucher.customerId}, ${receiptVoucher.paymentMethod}, '${receiptVoucher.voucherDate.toIso8601String()}', 
   '${receiptVoucher.referenceNo}', ${receiptVoucher.amount}, '${receiptVoucher.currency}', '${receiptVoucher.description}', ${receiptVoucher.approvalStatus}, '${receiptVoucher.createdAt.toIso8601String()}');
''',
      }),
    );
    return response;
  }

  static Future<List<RVListItem>> fetchAllRVRequests(
      int salesmanID, PaymentMethod paymentMethod) async {
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
    rv.Voucher_ID,
    rv.Voucher_Date,
    c.English_Name,
    rv.Amount,
    rv.Currency,
    rv.Description,
    rv.is_Deposited
FROM
    ReceiptVoucher rv
        LEFT JOIN
    customers c ON c.customer_ID = rv.Customer_ID
WHERE
    rv.Salesman_ID = $salesmanID
        AND rv.Payment_Method = ${paymentMethod.id}
ORDER BY rv.Voucher_Date DESC

''',
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List.generate(data.length, (i) {
        return RVListItem.fromJson(data[i]);
      });
    } else {
      return Future.error('Failed to load data');
    }
  }
}
