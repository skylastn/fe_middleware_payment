import 'package:get/get.dart';

import '../../../../presentation/main/payment/controllers/payment.controller.dart';

class PaymentControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(
      () => PaymentController(),
    );
  }
}
