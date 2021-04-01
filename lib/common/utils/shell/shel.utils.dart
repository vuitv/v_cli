import 'dart:io';

import 'package:process_run/process_run.dart';

import '../../../core/generator.dart';
import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../logger/log_utils.dart';
import '../pub_dev/pub_dev_api.dart';
import '../pubspec/pubspec_lock.dart';

class ShellUtils {
  static Future<void> pubGet() async {
    LogService.info('Running `flutter pub get` …');
    await run('flutter', ['pub', 'get'], verbose: true);
  }

  static Future<void> activatedNullSafe() async {
    await run('dart', ['migrate', '--apply-changes', '--skip-import-check'],
        verbose: true);
  }

  static Future<void> flutterCreate(
    String path,
    String org,
    String iosLang,
    String androidLang,
  ) async {
    LogService.info('Running `flutter create $path` …');

    await run(
        'flutter',
        [
          'create',
          '--no-pub',
          '-i',
          iosLang,
          '-a',
          androidLang,
          '--org',
          org,
          path,
        ],
        verbose: true);
  }

  static Future<void> update(
      [bool isGit = false, bool forceUpdate = false]) async {
    isGit = VuiCli.arguments.contains('--git');
    forceUpdate = VuiCli.arguments.contains('-f');
    if (!isGit && !forceUpdate) {
      var versionInPubDev =
          await PubDevApi.getLatestVersionFromPackage('vui_cli');

      var versionInstalled = await PubspecLock.getVersionCli(disableLog: true);

      if (versionInstalled == versionInPubDev) {
        return LogService.info(
            Translation(LocaleKeys.info_cli_last_version_already_installed.tr));
      }
    }

    LogService.info('Upgrading vui_cli …');
    var res;
    if (Platform.script.path.contains('flutter')) {
      if (isGit) {
        res = await run(
            'flutter',
            [
              'pub',
              'global',
              'activate',
              '-sgit',
              'https://github.com/vuitv/v_cli/'
            ],
            verbose: true);
      } else {
        res = await run(
            'flutter',
            [
              'pub',
              'global',
              'activate',
              'vui_cli',
            ],
            verbose: true);
      }
    } else {
      if (isGit) {
        res = await run(
            'pub',
            [
              'global',
              'activate',
              '-sgit',
              'https://github.com/vuitv/v_cli/'
            ],
            verbose: true);
      } else {
        res = await run(
            'pub',
            [
              'global',
              'activate',
              'vui_cli',
            ],
            verbose: true);
      }
    }
    if (res.stderr.toString().isNotEmpty) {
      return LogService.error(LocaleKeys.error_update_cli.tr);
    }
    LogService.success(LocaleKeys.sucess_update_cli.tr);
  }
}
