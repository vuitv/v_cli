import '../../interface/sample_interface.dart';

class NavigationSample extends Sample {
  NavigationSample(
      {String path = 'lib/infrastructure/navigation/navigation.dart'})
      : super(path);

  @override
  String get content => '''import 'package:get/get.dart';

import '../../presentation/screens.dart';
import 'routes.dart';

class Nav {
  static List<GetPage> routes = [
    GetPage(name: Routes.HOME, page: () => HomeScreen()),
  ];
}''';
}
