class ReceiptVoucher {
  final int voucherId;
  final String voucherNo;
  final int salesmanId;
  final int customerId;
  final int paymentMethod;
  final DateTime voucherDate;
  final String? referenceNo;
  final double amount;
  final String currency;
  final String? description;
  final int approvalStatus;
  final DateTime createdAt;

  ReceiptVoucher({
    required this.voucherId,
    required this.voucherNo,
    required this.salesmanId,
    required this.customerId,
    required this.paymentMethod,
    required this.voucherDate,
    this.referenceNo,
    required this.amount,
    this.currency = "EGP",
    this.description,
    this.approvalStatus = 0,
    required this.createdAt,
  });

  /// Convert from JSON (e.g., API response or database row)
  factory ReceiptVoucher.fromJson(Map<String, dynamic> json) {
    return ReceiptVoucher(
      voucherId: json['Voucher_ID'],
      voucherNo: json['Voucher_No'],
      salesmanId: json['Salesman_ID'],
      customerId: json['Customer_ID'],
      paymentMethod: json['Payment_Method'],
      voucherDate: DateTime.parse(json['Voucher_Date']),
      referenceNo: json['Reference_No'],
      amount: (json['Amount'] as num).toDouble(),
      currency: json['Currency'] ?? "EGP",
      description: json['Description'],
      approvalStatus: json['approval_status'] ?? 0,
      createdAt: DateTime.parse(json['Created_At']),
    );
  }

  /// Convert to JSON (e.g., for API request or local storage)
  Map<String, dynamic> toJson() {
    return {
      'Voucher_ID': voucherId,
      'Voucher_No': voucherNo,
      'Salesman_ID': salesmanId,
      'Customer_ID': customerId,
      'Payment_Method': paymentMethod,
      'Voucher_Date': voucherDate.toIso8601String(),
      'Reference_No': referenceNo,
      'Amount': amount,
      'Currency': currency,
      'Description': description,
      'approval_status': approvalStatus,
      'Created_At': createdAt.toIso8601String(),
    };
  }
}
