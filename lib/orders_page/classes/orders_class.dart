class Order {
  final int id;
  final int productId;
  final int customerId;
  final int salesmanId;
  final int qty;
  final DateTime date;

  Order({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.salesmanId,
    required this.qty,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'],
      productId: json['product_id'],
      customerId: json['customer_id'],
      salesmanId: json['salesman_id'],
      qty: json['qty'],
      date: DateTime.parse(json['order_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': id,
      'product_id': productId,
      'customer_id': customerId,
      'salesman_id': salesmanId,
      'qty': qty,
      'order_date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Order{id: $id, productId: $productId, customerId: $customerId, salesmanId: $salesmanId, qty: $qty, date: $date}';
  }
}
