import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_version_manager/src/presentation/donation/donation_screen.dart';
import 'package:flutter_version_manager/src/presentation/presentation.dart';
import 'package:flutter_version_manager/src/core/core.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: const CustomBackButton(),
        title: CustomTitle(
            title: 'Settings'.i18n, iconData: FluentIcons.settings_16_regular),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Section(title: 'Common'.i18n, children: [
            /// Theme switcher
            Row(
              children: [
                SizedBox(
                    width: 80,
                    child: Text(
                      'Theme'.i18n,
                      style: context.theme.textTheme.titleSmall,
                    )),
                isWindows || isMacOS || isWeb ? 8.width : 4.width,
                const ThemeSwitcher(),
              ],
            ),
            8.height,

            /// Language switcher
            Row(
              children: [
                SizedBox(
                    width: 80,
                    child: Text(
                      'Language'.i18n,
                      style: context.theme.textTheme.titleSmall,
                    )),
                8.width,
                const LanguageSwitcher(),
              ],
            ),

            const Divider(),
            ListTile(
              minLeadingWidth: 0,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              title: Text(
                'Reset to default settings'.i18n,
                style: context.theme.textTheme.titleSmall,
              ),
              subtitle: Text(
                  'Restore the settings to their default as when the application was first installed.'
                      .i18n),
              onTap: () {
                context.showAlertDialog(
                    title: 'Reset to default settings'.i18n,
                    content:
                        'Restore the settings to their default as when the application was first installed.'
                            .i18n,
                    action: () {
                      Properties.instance
                          .saveSettings(DefaultSettings.settings);
                      context.showSnackBar(
                          content: 'Default settings are restored.'.i18n);
                    });
              },
              trailing: const Icon(Icons.restart_alt),
            ),
          ]),
        ],
      ),
    );
  }
}

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  final languageStreamController = StreamController<String>();
  final supportedLanguages = ['English', 'Tiếng Việt', '中国', 'System default'];
  @override
  Widget build(BuildContext context) {
    final settingBloc = context.read<SettingBloc>();
    return StreamBuilder<String>(
        stream: languageStreamController.stream,
        initialData: Properties.instance.settings.language,
        builder: (context, languageState) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: context.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              value: languageState.data,
              onChanged: (String? language) {
                if (language != null) {
                  languageStreamController.add(language);
                  settingBloc.add(ChangeLanguageEvent(language: language));
                }
              },
              items: supportedLanguages
                  .map<DropdownMenuItem<String>>((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(language),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}
