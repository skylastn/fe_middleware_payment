import 'dart:async';

import 'package:get/get.dart';

import '../../../../../domain/model/response/duitku_order.dart';
import '../../../../../domain/model/state_status.dart';
import '../../controllers/payment.state.dart';

import '../../../../../domain/model/response/orders.dart';
import '../../../../../domain/model/response/spnpay_order.dart';

class DetailPaymentState {
  String paymentCode = '', orderId = '', errorMsg = '';
  PaymentCategory? paymentCategory;
  PaymentMethod? paymentMethod;
  bool isPayment = false;
  Orders? order;
  StateStatus status = StateStatus.inital;
  // PaymentType paymentType = PaymentType.duitku;
  SpnPayOrder spnPayOrder = SpnPayOrder();
  DuitkuOrder duitkuOrder = DuitkuOrder();
  LightSubscription<Orders?>? orderSubscribition;
  StreamSubscription<bool>? isInternetConnectedSubscription,
      isSocketConnectedSubscription;
}
