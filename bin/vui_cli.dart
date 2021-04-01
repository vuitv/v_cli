import 'package:vui_cli/core/generator.dart';
import 'package:vui_cli/exception_handler/exception_handler.dart';
import 'package:vui_cli/functions/version/version_update.dart';

Future<void> main(List<String> arguments) async {
  final command = VuiCli(arguments).findCommand();

  if (arguments.contains('--debug')) {
    if (command.validate()) {
      await command.execute().then((value) => checkForUpdate());
    }
  } else {
    try {
      if (command.validate()) {
        await command.execute().then((value) => checkForUpdate());
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
  }
}

/* void main(List<String> arguments) {
 Core core = Core();
  core
      .generate(arguments: List.from(arguments))
      .then((value) => checkForUpdate()); 
} */