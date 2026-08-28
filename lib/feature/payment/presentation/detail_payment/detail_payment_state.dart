import 'dart:async';
import 'package:get/get.dart';

import '../../../../shared/model/state_status.dart';
import '../../domain/model/response/duitku_order.dart';
import '../../domain/model/response/orders.dart';
import '../../domain/model/response/spnpay_order.dart';
import '../payment_method/payment_method_state.dart';

class DetailPaymentState {
  String paymentCode = '', orderId = '', errorMsg = '';
  PaymentCategory? paymentCategory;
  PaymentMethod? paymentMethod;
  bool isPayment = false;
  Orders? order;
  StateStatus status = StateStatus.inital;
  SpnPayOrder spnPayOrder = SpnPayOrder();
  DuitkuOrder duitkuOrder = DuitkuOrder();
  LightSubscription<Orders?>? orderSubscribition;
  LightSubscription<void>? socketReconnectSubscription;
  StreamSubscription<bool>? isInternetConnectedSubscription;
  StreamSubscription<bool>? isSocketConnectedSubscription;
}
