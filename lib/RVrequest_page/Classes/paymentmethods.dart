class PaymentMethod {
  final int id;
  final String paymentMethod;

  const PaymentMethod({
    required this.id,
    required this.paymentMethod,
  });

  /// Factory constructor from JSON (API/DB row)
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['Paymentmethod_ID'] ?? 0,
      paymentMethod: json['Paymentmethod'] ?? '',
    );
  }

  /// Convert to JSON (for API request or DB insert)
  Map<String, dynamic> toJson() {
    return {
      'Paymentmethod_ID': id,
      'Paymentmethod': paymentMethod,
    };
  }

  @override
  String toString() => 'PaymentMethod(id: $id, paymentMethod: $paymentMethod)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethod &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Example static constants (if you want fixed methods)
  static const PaymentMethod cash = PaymentMethod(id: 1, paymentMethod: 'Cash');
  static const PaymentMethod cheque =
      PaymentMethod(id: 2, paymentMethod: 'Cheque');

  static const List<PaymentMethod> methods = [
    cash,
    cheque,
  ];
}
