import 'package:get/get.dart';

import '../../feature/payment/presentation/detail_payment/detail_payment_binding.dart';
import '../../feature/payment/presentation/detail_payment/detail_payment_page.dart';
import '../../feature/payment/presentation/home/home_binding.dart';
import '../../feature/payment/presentation/home/home_page.dart';
import '../../feature/payment/presentation/payment_method/payment_method_binding.dart';
import '../../feature/payment/presentation/payment_method/payment_method_page.dart';
import 'routes.dart';

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => const PaymentMethodPage(),
      binding: PaymentMethodBinding(),
    ),
    GetPage(
      name: Routes.DETAILPAYMENT,
      page: () => const DetailPaymentPage(),
      binding: DetailPaymentBinding(),
    ),
  ];
}
