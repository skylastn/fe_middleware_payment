export enum PaymentCategoryKey {
  VA = "va",
  CC = "cc",
  QRIS = "qris",
  EWALLET = "ewallet",
  RETAIL = "retail",
  OTHER = "other",
}

export const fromCategoryKey = (key?: string | null): PaymentCategoryKey => {
  if (!key) return PaymentCategoryKey.OTHER;
  const k = key.toLowerCase();
  switch (k) {
    case "va":
    case "virtual-account":
    case "virtual_account":
      return PaymentCategoryKey.VA;
    case "cc":
    case "credit-card":
    case "credit_card":
      return PaymentCategoryKey.CC;
    case "qris":
      return PaymentCategoryKey.QRIS;
    case "ewallet":
    case "e-wallet":
      return PaymentCategoryKey.EWALLET;
    case "retail":
    case "convenience-store":
      return PaymentCategoryKey.RETAIL;
    default:
      return PaymentCategoryKey.OTHER;
  }
};
