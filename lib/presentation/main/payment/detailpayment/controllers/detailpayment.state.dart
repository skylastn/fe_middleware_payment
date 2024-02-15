import 'package:fe_middleware_payment/presentation/main/payment/controllers/payment.state.dart';

class DetailPaymentState {
  String paymentCode = '';
  PaymentCategory? paymentCategory;
  PaymentMethod? paymentMethod;
  bool isPayment = false;
}
