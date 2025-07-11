class Order {
  final int orderId;
  final int productId;
  final String productName;
  final int customerId;
  final String customerName;
  final int quantity;

  Order({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.customerId,
    required this.customerName,
    required this.quantity,
  });

  // Convert from Map (e.g. from database)
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      productId: map['productId'],
      productName: map['productName'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      quantity: map['quantity'],
    );
  }

  // Convert to Map (e.g. to insert into database)
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'customerId': customerId,
      'customerName': customerName,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'Order(orderId: $orderId, productId: $productId, productName: $productName, customerId: $customerId, customerName: $customerName, quantity: $quantity)';
  }
}
