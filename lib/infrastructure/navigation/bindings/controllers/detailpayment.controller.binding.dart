import 'package:get/get.dart';

import '../../../../presentation/main/payment/detailpayment/controllers/detailpayment.controller.dart';

class DetailPaymentControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPaymentController>(
      () => DetailPaymentController(),
    );
  }
}
