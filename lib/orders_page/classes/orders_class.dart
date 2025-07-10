class Order {
  final String productId;
  final String productName;
  final String customerId;
  final String customerName;
  final int quantity;

  Order({
    required this.productId,
    required this.productName,
    required this.customerId,
    required this.customerName,
    required this.quantity,
  });

  // Optional: Convert to/from Map for JSON or database
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      productId: map['productId'],
      productName: map['productName'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'customerId': customerId,
      'customerName': customerName,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'Order(productId: $productId, productName: $productName, customerId: $customerId, customerName: $customerName, quantity: $quantity)';
  }
}
