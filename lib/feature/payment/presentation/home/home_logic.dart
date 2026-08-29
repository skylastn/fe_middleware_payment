import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/model/state_status.dart';
import '../../application/order_service.dart';
import '../../domain/model/response/project.dart';
import '../../domain/model/response/spnpay_order.dart';
import 'home_state.dart';

class HomeLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final state = HomeState();
  final OrderService _orderService = OrderService();

  @override
  void onInit() {
    super.onInit();
    state.orderId = Get.parameters['reference'] ?? '';
    state.tabController = TabController(vsync: this, length: 2);
  }

  @override
  void onReady() {
    super.onReady();
    getDetailOrder();
  }

  @override
  void onClose() {
    state.tabController.dispose();
    super.onClose();
  }

  Future<void> getDetailOrder() async {
    state.status = StateStatus.loading;
    update();
    var response = await _orderService.getDetailOrder(reference: state.orderId);
    response.fold((l) {
      state.status = StateStatus.error;
      state.errorMsg = l.msg;
      update();
    }, (r) {
      state.status = StateStatus.success;
      state.order = r;
      if (state.order?.project?.projectType == ProjectType.spnpay) {
        if ((r.request ?? '').isNotEmpty) {
          try {
            state.spnPayOrder.request = SpnPayOrderRequest.fromJson(
              jsonDecode(r.request ?? ''),
            );
          } catch (_) {}
        }
        if ((r.response ?? '').isNotEmpty) {
          try {
            state.spnPayOrder.response = SpnPayOrderResponse.fromJson(
              jsonDecode(r.response ?? ''),
            );
          } catch (_) {}
        }
        if ((r.callback ?? '').isNotEmpty) {
          state.spnPayOrder.callback = r.callback ?? '';
        }
      }
      update();
    });
  }
}
