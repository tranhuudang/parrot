import 'package:flutter_version_manager/src/core/core.dart';
import 'package:upgrader/upgrader.dart';

class UpgraderConfig {
  static const _appcastURL =
      'https://raw.githubusercontent.com/tranhuudang/parrot/master/version.xml';
  static final upgrader = Upgrader(
    languageCode: Properties.instance.settings.language.toLocale().languageCode,
    //debugDisplayAlways: true,
    storeController: UpgraderStoreController(
      onWindows: () => UpgraderAppcastStore(appcastURL: _appcastURL),
      onMacOS: () => UpgraderAppcastStore(appcastURL: _appcastURL),
    ),
  );
}