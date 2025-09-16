class RVListItem {
  final int voucherId;
  final DateTime voucherDate;
  final String customerName;
  final double amount;
  final String currency;
  final String description;
  final bool isDeposited;

  RVListItem({
    required this.voucherId,
    required this.voucherDate,
    required this.customerName,
    required this.amount,
    required this.currency,
    required this.description,
    required this.isDeposited,
  });

  /// Convert SQL row (Map) → ViewModel
  factory RVListItem.fromJson(Map<String, dynamic> json) {
    return RVListItem(
      voucherId: json['Voucher_ID'] as int,
      voucherDate: DateTime.parse(json['Voucher_Date']),
      customerName: json['English_Name'] ?? '',
      amount: (json['Amount'] as num).toDouble(),
      currency: json['Currency'] ?? '',
      description: json['Description'] ?? '',
      isDeposited:
          (json['is_Deposited'] == 1), // SQLite often stores bool as int
    );
  }

  /// Convert ViewModel → JSON (for API / storage)
  Map<String, dynamic> toJson() {
    return {
      'Voucher_ID': voucherId,
      'Voucher_Date': voucherDate.toIso8601String(),
      'English_Name': customerName,
      'Amount': amount,
      'Currency': currency,
      'Description': description,
      'is_Deposited': isDeposited ? 1 : 0,
    };
  }
}
