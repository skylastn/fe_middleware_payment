import 'dart:async';
import 'package:get/get.dart';

import '../../../../shared/model/state_status.dart';
import '../../domain/model/response/orders.dart';

class DetailPaymentState {
  String orderId = '';
  String errorMsg = '';
  String? qrString;
  String? vaNumber;
  String? checkoutUrl;

  bool isPayment = false;
  Orders? order;
  StateStatus status = StateStatus.inital;

  LightSubscription<Orders?>? orderSubscribition;
  LightSubscription<void>? socketReconnectSubscription;
  StreamSubscription<bool>? isInternetConnectedSubscription;
  StreamSubscription<bool>? isSocketConnectedSubscription;
}
