class Currency {
  final int id;
  final String code; // e.g. "EGP"
  final String name; // e.g. "Egyptian Pound"

  const Currency({
    required this.id,
    required this.code,
    required this.name,
  });

  /// Factory constructor from JSON (API/DB row)
  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['Currency_ID'] ?? 0,
      code: json['Currency_Code'] ?? '',
      name: json['Currency_Name'] ?? '',
    );
  }

  /// Convert to JSON (for API request or DB insert)
  Map<String, dynamic> toJson() {
    return {
      'Currency_ID': id,
      'Currency_Code': code,
      'Currency_Name': name,
    };
  }

  @override
  String toString() => 'Currency(id: $id, code: $code, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  /// Example static constants (common currencies)
  static const Currency egp =
      Currency(id: 1, code: 'EGP', name: 'Egyptian Pound');
  static const Currency usd = Currency(id: 2, code: 'USD', name: 'US Dollar');
  static const Currency eur = Currency(id: 3, code: 'EUR', name: 'Euro');

  static const List<Currency> currencies = [
    egp,
    usd,
    eur,
  ];
}
