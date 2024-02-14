import 'package:fe_middleware_payment/infrastructure/shared/utils/snackbar.dart';
import 'package:fe_middleware_payment/presentation/main/payment/controllers/payment.state.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';

class PaymentController extends GetxController {
  PaymentState state = PaymentState();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    state.orderId = Get.parameters['orderId'] ?? '';
    if (state.orderId.isEmpty) {
      Snackbar.showInfo(message: 'Sorry Order ID is Empty');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  routeToDetail(PaymentMethod content, PaymentCategory category) {
    if (!['BCA_VA', 'EW_DANA', 'QRIS_SHOPEE'].contains(content.paymentCode)) {
      Snackbar.showInfo(message: 'Unsupport Payment Method');
      return;
    }
    Get.toNamed(
      Routes.DETAILPAYMENT,
      parameters: {
        'paymentCode': content.paymentCode,
        'orderId': state.orderId,
        'paymentType': category.paymentType.name,
      },
    );
  }
}
