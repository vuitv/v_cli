import '../../common/utils/logger/log_utils.dart';
import '../../core/locales.g.dart';
import '../../extensions.dart';
import '../impl/args_mixin.dart';

abstract class Command with ArgsMixin {
  String get commandName;

  List<String> get alias => [];

  List<String> get acceptedFlags => [];

  /// hint for command line
  String get hint;

  /// validate command line arguments
  bool validate() {
    var flagsNotAccepts = flags;
    flagsNotAccepts.removeWhere((element) => acceptedFlags.contains(element));
    if (flagsNotAccepts.isNotEmpty) {
      LogService.info(LocaleKeys.info_unnecessary_flag.trArgsPlural(
        LocaleKeys.info_unnecessary_flag_prural,
        flagsNotAccepts.length,
        [flagsNotAccepts.toString()],
      ));
    }
    return true;
  }

  /// execute command
  Future<void> execute();

  /// childrens command
  List<Command> get childrens => [];
}
