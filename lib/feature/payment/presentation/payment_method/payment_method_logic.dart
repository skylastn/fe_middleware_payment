import 'package:get/get.dart';

import '../../../../shared/navigation/routes.dart';
import '../../../../shared/utility/snackbar.dart';
import 'payment_method_state.dart';

class PaymentMethodLogic extends GetxController {
  final state = PaymentMethodState();

  @override
  void onReady() {
    super.onReady();
    state.orderId = Get.parameters['reference'] ?? '';
    if (state.orderId.isEmpty) {
      Snackbar.showInfo(message: 'Sorry Order ID is Empty');
    }
  }

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
