import 'package:get/get.dart';
import 'detail_payment_logic.dart';

class DetailPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPaymentLogic>(() => DetailPaymentLogic());
  }
}
