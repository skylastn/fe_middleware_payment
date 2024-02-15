import 'package:fe_middleware_payment/infrastructure/shared/constants/sample.dart';
import 'package:get/get.dart';

import '../../controllers/payment.state.dart';
import 'detailpayment.state.dart';

class DetailPaymentController extends GetxController {
  DetailPaymentState state = DetailPaymentState();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    state.paymentCategory = getSelectedPaymentCategory(
      Get.parameters['paymentType'] ?? '',
    );
    state.paymentCode = Get.parameters['paymentCode'] ?? '';
    state.paymentMethod = getSelectedPaymentMethod();
  }

  @override
  void onReady() {
    super.onReady();
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
}
