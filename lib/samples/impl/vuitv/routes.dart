import '../../interface/sample_interface.dart';

class RouteSample extends Sample {
  String initial;
  RouteSample(this.initial,
      {String path = 'lib/infrastructure/navigation/routes.dart'})
      : super(path);
  @override
  String get content => '''class Routes {
  static Future<String> get initialRoute async => HOME;

  static const HOME = '/home';
}''';
}
