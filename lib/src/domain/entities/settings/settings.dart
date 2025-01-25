import 'package:freezed_annotation/freezed_annotation.dart';
part 'settings.freezed.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    /// Save current theme of this app in this param, it holds string value of [ThemeMode] with value:
    /// ThemeMode.system, ThemeMode.dark, ThemeMode.light
    required String themeMode,

    /// Adaptive theme use DynamicTheme package to generate colorScheme
    required bool enableAdaptiveTheme,

    /// Open app count will trigger a specific function when user use app for a period of time
    required int openAppCount,
    required bool didRateApp,

    /// Language of app, those value : English, Tiếng Việt, System default will be convert
    /// to [Locale('en', 'US')] to change value of the app
    required String language,

    /// Hold windows size value
    required double windowsWidth,

    /// Hold windows size value
    required double windowsHeight,

    /// Hold primary color for the app, it can be generate to other colors later to
    /// create colorScheme
    required int themeColor,
  }) = _Setting;
}
