import 'package:fe_middleware_payment/presentation/main/home/controllers/home.state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeState state = HomeState();

  @override
  void onInit() {
    super.onInit();
    state.tabController = TabController(vsync: this, length: 2);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    state.tabController.dispose();
  }
}
