import 'dart:io';

import 'package:vui_cli/samples/impl/vuitv/config_example.dart';
import 'package:vui_cli/samples/impl/vuitv/main.dart';

import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_list_directory.dart';
import '../../../../functions/create/create_main.dart';
import '../../commads_export.dart';
import '../../install/install_get.dart';

Future<void> createInitVuiTv() async {
  var canContinue = await createMain();
  if (!canContinue) return;
  if (!PubspecUtils.isServerProject) {
    await installGet();
  }
  var initialDirs = [
    Directory(Structure.replaceAsExpected(path: 'lib/controllers/')),
    Directory(Structure.replaceAsExpected(path: 'lib/infrastructure/navigation/')),
    Directory(Structure.replaceAsExpected(path: 'lib/infrastructure/api/')),
    Directory(Structure.replaceAsExpected(path: 'lib/infrastructure/extensions/')),
    Directory(Structure.replaceAsExpected(path: 'lib/infrastructure/services/')),
    Directory(Structure.replaceAsExpected(path: 'lib/infrastructure/store/')),
    Directory(Structure.replaceAsExpected(path: 'lib/models/')),
    Directory(Structure.replaceAsExpected(path: 'lib/presentation/')),
    Directory(Structure.replaceAsExpected(path: 'lib/presentation/widgets/')),
    Directory(Structure.replaceAsExpected(path: 'lib/utils/')),
    Directory(Structure.replaceAsExpected(path: 'lib/values/')),
  ];
  VuiTvMainSample().create();
  ConfigExampleSample().create();
  await Future.wait([
    CreateScreenCommand().execute(),
  ]);
  createListDirectory(initialDirs);

  LogService.success(Translation(LocaleKeys.sucess_clean_Pattern_generated).tr);
}
