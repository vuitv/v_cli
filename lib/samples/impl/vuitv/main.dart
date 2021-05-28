import '../../interface/sample_interface.dart';

class VuiTvMainSample extends Sample {
  VuiTvMainSample() : super('lib/main.dart', overwrite: true);

  @override
  String get content => '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'intrastructure/navigation/navigation.dart';
import 'intrastructure/navigation/routes.dart';
import 'values/themes.dart';

void main() async {
  final initialRoute = await Routes.initialRoute;
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    print('=====Build Main=====');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: Themes.lightTheme,
      darkTheme: Themes.lightTheme,
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
  }
}''';
}
