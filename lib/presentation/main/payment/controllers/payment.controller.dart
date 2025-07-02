import 'package:fe_middleware_payment/infrastructure/shared/utils/snackbar.dart';
import 'package:fe_middleware_payment/presentation/main/payment/controllers/payment.state.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/navigation/routes.dart';

class PaymentController extends GetxController {
  PaymentState state = PaymentState();

  final count = 0.obs;

  @override
  void onReady() {
    super.onReady();
    state.orderId = Get.parameters['reference'] ?? '';
    if (state.orderId.isEmpty) {
      Snackbar.showInfo(message: 'Sorry Order ID is Empty');
    }
  }

  void increment() => count.value++;

  void routeToDetail(PaymentMethod content, PaymentCategory category) {
    if (category.paymentType != PaymentType.bankTransfer) {
      Snackbar.showInfo(message: 'Unsupport Payment Method');
      return;
    }
    Get.toNamed(
      Routes.DETAILPAYMENT,
      parameters: {
        'paymentCode': content.paymentCode,
        'reference': state.orderId,
        'paymentType': category.paymentType.name,
      },
    );
  }
}
