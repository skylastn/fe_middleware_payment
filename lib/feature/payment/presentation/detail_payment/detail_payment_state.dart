import 'dart:async';
import 'package:get/get.dart';

import '../../../../shared/model/state_status.dart';
import '../../domain/model/response/duitku_order.dart';
import '../../domain/model/response/orders.dart';
import '../../domain/model/response/payment_category.dart';
import '../../domain/model/response/payment_method.dart';
import '../../domain/model/response/spnpay_order.dart';

class DetailPaymentState {
  String paymentCode = '';
  String paymentName = '';
  String categoryTitle = '';
  String paymentType = '';
  String imageUrl = '';
  String from = '';
  String orderId = '';
  String errorMsg = '';
  String? qrString;
  String? vaNumber;
  String? checkoutUrl;

  PaymentCategory? paymentCategory;
  PaymentResponse? paymentMethod;

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
