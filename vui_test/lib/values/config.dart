import 'package:flutter/services.dart';

enum Environment { DEV, PRODUCT }

class Config {
  static Map<String, dynamic> _config = _Config.debugConstants;

  static Environment _env = Environment.DEV;

  static Future initializeApp() async {
    final flavor = await MethodChannel('flavor')
        .invokeMethod<String>('getFlavor')
        .catchError((error) {
      print('FAILED TO LOAD FLAVOR: $error');
    });
    if (flavor == 'product') {
      Config._setEnvironment(Environment.PRODUCT);
    } else {
      Config._setEnvironment(Environment.DEV);
    }
  }

  static void _setEnvironment(Environment env) {
    _env = env;
    switch (env) {
      case Environment.DEV:
        _config = _Config.debugConstants;
        break;
      case Environment.PRODUCT:
        _config = _Config.prodConstants;
        break;
      default:
        _config = _Config.debugConstants;
    }
  }

  static Environment get getEnvironment => _env;

  static get apiAuthority => _config[_Config.apiAuthority];
  static get apiPath => _config[_Config.apiPath];
}

class _Config {
  static const String apiAuthority = "API_AUTHORITY";
  static const String apiPath = "API_PATH";

  static Map<String, dynamic> debugConstants = {
    apiAuthority: "",
    apiPath: "",
  };

  static Map<String, dynamic> prodConstants = {
    apiAuthority: "",
    apiPath: "",
  };
}
