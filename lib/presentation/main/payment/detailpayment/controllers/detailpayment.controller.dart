import 'dart:convert';
import 'package:fe_middleware_payment/infrastructure/repository/order_repository.dart';
import 'package:fe_middleware_payment/infrastructure/shared/constants/sample.dart';
import 'package:get/get.dart';
import '../../../../../domain/model/response/spnpay_order.dart';
import '../../../../../domain/model/state_status.dart';
import '../../controllers/payment.state.dart';
import 'detailpayment.state.dart';

class DetailPaymentController extends GetxController {
  DetailPaymentState state = DetailPaymentState();
  OrderRepository repo = OrderRepository();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    state.paymentCategory = getSelectedPaymentCategory(
      Get.parameters['paymentType'] ?? '',
    );
    state.paymentCode = Get.parameters['paymentCode'] ?? '';
    state.paymentMethod = getSelectedPaymentMethod();
    state.orderId = Get.parameters['reference'] ?? '';
  }

  @override
  void onReady() {
    super.onReady();
    getDetailOrder();
  }

  @override
  void onClose() {
    super.onClose();
  }

  PaymentCategory getSelectedPaymentCategory(String paymentType) =>
      listPayment.firstWhere(
        (element) => paymentType == element.paymentType.name,
      );

  PaymentMethod getSelectedPaymentMethod() =>
      state.paymentCategory!.paymentMethod.firstWhere(
        (element) => state.paymentCode == element.paymentCode,
      );

  Future<void> getDetailOrder({bool isLoading = true}) async {
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
      update();
    });
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
}
