import 'package:intl/intl.dart';

class OrderDetailsVM {
  final int id;
  final int productId;
  final int customerId;
  final int salesmanId;
  final int qty;
  final DateTime date;
  final String productName;
  final String customerName;

  OrderDetailsVM({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.salesmanId,
    required this.qty,
    required this.date,
    required this.productName,
    required this.customerName,
  });

  factory OrderDetailsVM.fromJson(Map<String, dynamic> json) {
    return OrderDetailsVM(
      id: json['order_id'],
      productId: json['product_id'],
      customerId: json['customer_id'],
      salesmanId: json['salesman_id'],
      qty: json['qty'],
      date: DateFormat("yyyy-MM-dd").parse(json['order_date']),
      productName: json['product_name'], // must come from SQL JOIN
      customerName: json['customer_name'], // must come from SQL JOIN
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'order_id': id,
      'product_id': productId,
      'customer_id': customerId,
      'salesman_id': salesmanId,
      'qty': qty,
      'order_date': date.toIso8601String(),
      'product_name': productName,
      'customer_name': customerName,
    };
  }
}
