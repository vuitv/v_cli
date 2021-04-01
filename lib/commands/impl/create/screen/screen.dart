import 'dart:io';

import 'package:cli_menu/cli_menu.dart';
import 'package:recase/recase.dart';

import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/generator.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/exports_files/add_export.dart';
import '../../../../functions/routes/arc_add_route.dart';
import '../../../../samples/impl/get_binding.dart';
import '../../../../samples/impl/get_controller.dart';
import '../../../../samples/impl/get_view.dart';
import '../../../interface/command.dart';

class CreateScreenCommand extends Command {
  @override
  String get commandName => 'screen';
  @override
  Future<void> execute() async {
    var isProject = false;
    if (VuiCli.arguments[0] == 'create') {
      isProject = VuiCli.arguments[1].split(':').first == 'project';
    }
    var name = isProject ? 'home' : this.name;

    var _fileModel =
        Structure.model('', 'screen', true, on: onCommand, folderName: name);
    var pathSplit = Structure.safeSplitPath(_fileModel.path);

    var path = pathSplit.join('/');
    path = Structure.replaceAsExpected(path: path);
    if (Directory(path).existsSync()) {
      LogService.info(Translation(LocaleKeys.ask_existing_page.trArgs([name])));
      final menu = Menu([
        LocaleKeys.options_yes.tr,
        LocaleKeys.options_no.tr,
      ]);
      final result = menu.choose();
      if (result.index == 0) {
        _writeFiles(path, name, overwrite: true);
      }
    } else {
      Directory(path).createSync(recursive: true);
      _writeFiles(path, name);
    }
  }

  @override
  String get hint => Translation(LocaleKeys.hint_create_screen).tr;

  @override
  bool validate() {
    return true;
  }

  void _writeFiles(String path, String name, {bool overwrite = false}) {
    var isServer = PubspecUtils.isServerProject;

    var controller = handleFileCreate(name, 'controller', path, true,
        ControllerSample('', name, isServer), 'controllers', '.');

    var controllerImport = Structure.pathToDirImport(controller.path);

    var view = handleFileCreate(
        name,
        'screen',
        path,
        false,
        GetViewSample(
          '',
          '${name.pascalCase}Screen',
          '${name.pascalCase}Controller',
          controllerImport,
          isServer,
        ),
        '',
        '.');
    ;
    var binding = handleFileCreate(
        name,
        'controller.binding',
        '',
        true,
        BindingSample(
          '',
          name,
          '${name.pascalCase}ControllerBinding',
          controllerImport,
          isServer,
        ),
        'controllers',
        '.');

    var exportView = 'package:${PubspecUtils.getProjectName()}/'
        '${Structure.pathToDirImport(view.path)}';
    addExport('lib/presentation/screens.dart', "export '$exportView';");

    addExport(
        'lib/infrastructure/navigation/bindings/controllers/controllers_bindings.dart',
        "export 'package:${PubspecUtils.getProjectName()}/${Structure.pathToDirImport(binding.path)}'; ");
    arcAddRoute(name);
  }
}
