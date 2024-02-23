import 'package:fe_middleware_payment/domain/model/state_status.dart';
import 'package:fe_middleware_payment/presentation/main/payment/controllers/payment.state.dart';

import '../../../../../domain/model/response/orders.dart';
import '../../../../../domain/model/response/spnpay_order.dart';

class DetailPaymentState {
  String paymentCode = '', orderId = '', errorMsg = '';
  PaymentCategory? paymentCategory;
  PaymentMethod? paymentMethod;
  bool isPayment = false;
  Orders? order;
  StateStatus status = StateStatus.inital;
  SpnPayOrder spnPayOrder = SpnPayOrder();
}
