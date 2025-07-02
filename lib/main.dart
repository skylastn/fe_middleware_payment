// import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'; // Import ini
import 'package:get/get.dart';

import 'app/core/dependency_injection.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  if (kIsWeb) {
    // setPathUrlStrategy();
    usePathUrlStrategy();
  }
  WidgetsFlutterBinding.ensureInitialized();
  await DenpendencyInjection.start();
  await DenpendencyInjection.inject();
  var initialRoute = await Routes.initialRoute;
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      enableLog: kDebugMode,
      debugShowCheckedModeBanner: kDebugMode,
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
