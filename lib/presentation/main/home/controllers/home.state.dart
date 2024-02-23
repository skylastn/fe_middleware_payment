import 'package:fe_middleware_payment/domain/model/response/spnpay_order.dart';
import 'package:fe_middleware_payment/domain/model/state_status.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/response/orders.dart';

class HomeState {
  late TabController tabController;
  int tabIndex = 0;
  String orderId = 'OTDN-ORD-29';
  StateStatus status = StateStatus.inital;
  String errorMsg = '';
  Orders? order;
  SpnPayOrder spnPayOrder = SpnPayOrder();
}
