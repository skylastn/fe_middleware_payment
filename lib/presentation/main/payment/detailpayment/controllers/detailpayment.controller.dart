import 'dart:convert';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/global/network_logic.dart';
import '../../../../../app/global/socket_logic.dart';
import '../../../../../infrastructure/repository/order_repository.dart';
import '../../../../../shared/constants/sample.dart';
import '../../../../../shared/utils/snackbar.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import '../../../../../domain/model/response/duitku_order.dart';
import '../../../../../domain/model/response/project.dart';
import '../../../../../domain/model/response/spnpay_order.dart';
import '../../../../../domain/model/state_status.dart';
import '../../controllers/payment.state.dart' as paymentstate;
import 'detailpayment.state.dart';

class DetailPaymentController extends GetxController {
  DetailPaymentState state = DetailPaymentState();
  OrderRepository repo = OrderRepository();
  final socketLogic = Get.find<SocketLogic>();
  final networkLogic = Get.find<NetworkLogic>();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    state.orderId = Get.parameters['reference'] ?? '';
  }

  @override
  void onReady() {
    super.onReady();
    init();
  }

  Future<void> init() async {
    await getDetailOrder();
    state.paymentCategory = getSelectedPaymentCategory(
      state.order?.paymentMethod ?? '',
    );
    state.paymentCode = state.order?.paymentMethod ?? '';
    state.paymentMethod = getSelectedPaymentMethod();
    listenOrder();
    update();
  }

  paymentstate.PaymentCategory? getSelectedPaymentCategory(String paymentType) {
    // Get.log('paymentType : $paymentType');
    for (var cat in listPayment) {
      var found = cat.paymentMethod.firstWhereOrNull(
        (element) => paymentType == element.paymentCode,
      );
      if (found != null) {
        return cat;
      }
    }
    return null;
  }

  paymentstate.PaymentMethod getSelectedPaymentMethod() =>
      state.paymentCategory!.paymentMethod.firstWhere(
        (element) => state.paymentCode == element.paymentCode,
      );

  void listenOrder() {
    state.orderSubscribition?.cancel();
    state.orderSubscribition = socketLogic.orderStream.listen((data) {
      if (data == null) {
        return;
      }
      // Get.log('run here : ${data.toJson()}');
      if (data.reference == state.orderId) {
        state.order = data;
        handleSuccess(isRedirect: true);
        update();
      }
    });
  }

  void listenConnection() {
    state.isInternetConnectedSubscription?.cancel();
    state.isInternetConnectedSubscription =
        networkLogic.isConnected.listen((data) async {
      if (!data) {
        return;
      }
      await getDetailOrder(isRedirect: true);
    });
  }

  void listenSocket() {
    state.isSocketConnectedSubscription?.cancel();
    state.isSocketConnectedSubscription =
        networkLogic.isConnected.listen((data) async {
      if (!data) {
        return;
      }
      await getDetailOrder(isRedirect: true);
    });
  }

  Future<void> getDetailOrder(
      {bool isLoading = true, bool isRedirect = false}) async {
    if (isLoading) {
      state.status = StateStatus.loading;
    }
    update();
    var response = await repo.getDetailOrder(reference: state.orderId);
    response.fold((l) {
      state.status = StateStatus.error;
      state.errorMsg = l.msg;
      update();
    }, (r) {
      state.status = StateStatus.success;
      state.order = r;
      handleSuccess(isRedirect: isRedirect);
      update();
    });
  }

  Future<void> handleSuccess({bool isRedirect = false}) async {
    if (state.order == null) return;
    // state.paymentType =
    //     PaymentType.fromName(state.order?.paymentMethods?.from ?? '');
    switch (state.order?.project?.projectType) {
      case ProjectType.spnpay:
        if ((state.order?.request ?? '').isNotEmpty) {
          state.spnPayOrder.request = SpnPayOrderRequest.fromJson(
            jsonDecode(state.order?.request ?? ''),
          );
        }
        if ((state.order?.response ?? '').isNotEmpty) {
          state.spnPayOrder.response = SpnPayOrderResponse.fromJson(
            jsonDecode(state.order?.response ?? ''),
          );
        }
        if ((state.order?.callback ?? '').isNotEmpty) {
          state.spnPayOrder.callback = state.order?.callback ?? '';
        }
      case ProjectType.duitku:
        if ((state.order?.request ?? '').isNotEmpty) {
          state.duitkuOrder.request = DuitkuOrderRequest.fromMap(
            jsonDecode(state.order?.request ?? ''),
          );
        }
        if ((state.order?.response ?? '').isNotEmpty) {
          state.isPayment = true;
          state.duitkuOrder.response = DuitkuOrderResponse.fromMap(
            jsonDecode(state.order?.response ?? ''),
          );
        }
        if ((state.order?.callback ?? '').isNotEmpty) {
          state.duitkuOrder.callback = DuitkuOrderCallback.fromMap(
            jsonDecode(state.order?.callback ?? ''),
          );
        }
      default:
    }
    if (isRedirect) {
      if (state.order?.status == 'SUCCESS') {
        if (state.order?.project?.projectType == ProjectType.duitku) {
          Snackbar.showInfo(message: 'Payment Success');
          await Future.delayed(const Duration(seconds: 1));
          _launchUrl(state.duitkuOrder.request?.returnUrl ?? '');
          return;
        }
      }
    }
  }

  Future<void> createOrderPayment() async {
    if (state.order?.response != null) {
      update();
      return;
    }
    state.status = StateStatus.loading;
    update();
    var response = await repo.createOrderPayment(
      paymentMethod: state.paymentMethod?.paymentCode ?? '',
      reference: state.orderId,
    );
    response.fold((l) {
      state.status = StateStatus.error;
      state.errorMsg = l.msg;
      update();
    }, (r) async {
      getDetailOrder(isLoading: false);
    });
  }

  Future<void> saveQRCode(
    String qrContent,
    GlobalKey<State<StatefulWidget>> globalKey,
  ) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    Uint8List? bytes = byteData?.buffer.asUint8List();
    await FileSaver.instance.saveFile(name: 'qrcode.png', bytes: bytes);
    Snackbar.showInfo(message: 'File saved to storage successfully!');
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      // throw Exception('Could not launch $url');
      Snackbar.showInfo(message: 'Could not launch $url');
    }
  }
}
