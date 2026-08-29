enum PaymentCategoryKey {
  va,
  qris,
  cc,
  ewallet,
  retail,
  unknown;

  static PaymentCategoryKey fromKey(String? key) {
    if (key == null) return PaymentCategoryKey.unknown;
    final lower = key.toLowerCase().trim();
    switch (lower) {
      case 'va':
        return PaymentCategoryKey.va;
      case 'qris':
        return PaymentCategoryKey.qris;
      case 'cc':
        return PaymentCategoryKey.cc;
      case 'ewallet':
        return PaymentCategoryKey.ewallet;
      case 'retail':
        return PaymentCategoryKey.retail;
      default:
        return PaymentCategoryKey.unknown;
    }
  }

  bool get isQris => this == PaymentCategoryKey.qris;
  bool get isVa => this == PaymentCategoryKey.va;
  bool get isCreditCard => this == PaymentCategoryKey.cc;
  bool get isEwallet => this == PaymentCategoryKey.ewallet;
  bool get isRetail => this == PaymentCategoryKey.retail;
}
