import 'dart:io';

import 'package:cli_dialog/cli_dialog.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../../../../common/utils/json_serialize/model_generator.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../exception_handler/exceptions/cli_exception.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../models/file_model.dart';
import '../../../../samples/impl/get_provider.dart';
import '../../../interface/command.dart';

class GenerateModelCommand extends Command {
  @override
  String get commandName => 'model';
  @override
  Future<void> execute() async {
    var name = p.basenameWithoutExtension(withArgument).pascalCase;
    if (withArgument.isEmpty) {
      final dialog = CLI_Dialog(questions: [
        [LocaleKeys.ask_model_name.tr, 'name']
      ]);
      var result = dialog.ask()['name'] as String;
      name = result.pascalCase;
    }

    FileModel _fileModel;
    final classGenerator = ModelGenerator(
        name, containsArg('--private'), containsArg('--withCopy'));

    /* if (findFolderByName('models') != null) {
      _fileModel = Structure.model(name, 'model', onCommand != '',
          on: onCommand != '' ? onCommand : 'models', folderName: 'models');
    } else {
      _fileModel = Structure.model(name, 'model', false, on: onCommand);
    } */
    _fileModel = Structure.model(name, 'model', false, on: onCommand);

    var dartCode = classGenerator.generateDartClasses(await _jsonRawData);

    var modelPath = '${_fileModel.path}_model.dart';

    var model = writeFile(modelPath, dartCode.result, overwrite: true);

    for (var warning in dartCode.warnings) {
      LogService.info('warning: ${warning.path} ${warning.warning} ');
    }
    if (!containsArg('--skipProvider')) {
      var pathSplit = Structure.safeSplitPath(modelPath);
      pathSplit.removeWhere((element) => element == '.' || element == 'lib');
      handleFileCreate(
        name,
        'provider',
        onCommand,
        true,
        ProviderSample(
          name,
          createEndpoints: true,
          modelPath: Structure.pathToDirImport(model.path),
        ),
        'providers',
      );
    }
  }

  @override
  String get hint => LocaleKeys.hint_generate_model.tr;

  @override
  bool validate() {
    if ((withArgument.isEmpty || p.extension(withArgument) != '.json') &&
        fromArgument.isEmpty) {
      var codeSample =
          'get generate model on home with assets/models/user.json';
      throw CliException(LocaleKeys.error_invalid_json.trArgs([withArgument]),
          codeSample: codeSample);
    }
    return true;
  }

  Future<String> get _jsonRawData async {
    if (withArgument.isNotEmpty) {
      return await File(withArgument).readAsString();
    } else {
      try {
        var result = await get(fromArgument);
        return result.body;
      } on Exception catch (_) {
        throw CliException(
            LocaleKeys.error_failed_to_connect.trArgs([fromArgument]));
      }
    }
  }
}
