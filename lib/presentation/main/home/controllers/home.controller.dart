import 'dart:convert';

import '../../../../domain/model/response/spnpay_order.dart';
import '../../../../domain/model/state_status.dart';
import '../../../../infrastructure/repository/order_repository.dart';
import 'home.state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/model/response/project.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeState state = HomeState();
  OrderRepository repo = OrderRepository();

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
    super.onClose();
    state.tabController.dispose();
  }

  Future<void> getDetailOrder() async {
    state.status = StateStatus.loading;
    update();
    var response = await repo.getDetailOrder(reference: state.orderId);
    response.fold((l) {
      state.status = StateStatus.error;
      state.errorMsg = l.msg;
      update();
    }, (r) {
      state.status = StateStatus.success;
      state.order = r;
      if (state.order?.project?.projectType == ProjectType.spnpay) {
        if ((r.request ?? '').isNotEmpty) {
          state.spnPayOrder.request = SpnPayOrderRequest.fromJson(
            jsonDecode(r.request ?? ''),
          );
        }
        if ((r.response ?? '').isNotEmpty) {
          state.spnPayOrder.response = SpnPayOrderResponse.fromJson(
            jsonDecode(r.response ?? ''),
          );
        }
        if ((r.callback ?? '').isNotEmpty) {
          state.spnPayOrder.callback = r.callback ?? '';
        }
      }

      update();
    });
  }
}
