import 'package:flutter/material.dart';
import '../../../../shared/model/state_status.dart';
import '../../domain/model/response/orders.dart';
import '../../domain/model/response/spnpay_order.dart';

class HomeState {
  late TabController tabController;
  int tabIndex = 0;
  String orderId = 'OTDN-ORD-29';
  StateStatus status = StateStatus.inital;
  String errorMsg = '';
  Orders? order;
  SpnPayOrder spnPayOrder = SpnPayOrder();
}
