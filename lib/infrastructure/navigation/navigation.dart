import 'package:get/get.dart';

import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

// class EnvironmentsBadge extends StatelessWidget {
//   final Widget child;
//   const EnvironmentsBadge({super.key, required this.child});
//   @override
//   Widget build(BuildContext context) {
//     var env = dotenv.env;
//     return env['ENVIRONTMENT'] != 'production'
//         ? Banner(
//             location: BannerLocation.topStart,
//             message: env['ENVIRONTMENT'] ?? '',
//             color: env['ENVIRONTMENT'] == 'development'
//                 ? Colors.blue
//                 : Colors.purple,
//             child: child,
//           )
//         : SizedBox(child: child);
//   }
// }

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => PaymentScreen(),
      binding: PaymentControllerBinding(),
    ),
    GetPage(
      name: Routes.DETAILPAYMENT,
      page: () => DetailPaymentScreen(),
      binding: DetailPaymentControllerBinding(),
    ),
  ];
}
