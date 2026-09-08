export class UrlPath {
  // Client payment checkout routes
  static readonly CLIENT_ORDER_DETAIL = "api/client/order/detail";
  static readonly CLIENT_ORDER_CHECK_STATUS = "api/client/order/checkOrderStatus";
  static readonly CLIENT_ORDER_CREATE_PAYMENT = "api/client/order/createPayment";

  static readonly CLIENT_PAYMENT_CATEGORY = "api/client/payment/getPaymentCategory";
  static readonly CLIENT_PAYMENT_METHOD = "api/client/payment/getPaymentMethod";
  static readonly CLIENT_PAYMENT_DETAIL = "api/client/payment/getDetailPaymentMethod";
}
