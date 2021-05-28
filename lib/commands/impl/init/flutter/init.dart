import 'package:cli_menu/cli_menu.dart';

import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../interface/command.dart';
import 'init_getxpattern.dart';
import 'init_katteko.dart';
import 'init_vuitv.dart';

class InitCommand extends Command {
  @override
  String get commandName => 'init';

  @override
  Future<void> execute() async {
    LogService.info('Choose a project structure?');
    final menu = Menu([
      'GetX Pattern (by Kauê)',
      'CLEAN (by Arktekko)',
      'VuiTv Pattern',
    ]);
    final result = menu.choose();

    switch (result.index) {
      case 0:
        await createInitGetxPattern();
        break;
      case 1:
        await createInitKatekko();
        break;
      case 2:
        await createInitVuiTv();
        break;
      default:
        await createInitGetxPattern();
    }

    if (!PubspecUtils.isServerProject) {
      await ShellUtils.pubGet();
    }
    return;
  }

  @override
  String get hint => Translation(LocaleKeys.hint_init).tr;

  @override
  bool validate() {
    return true;
  }
}
