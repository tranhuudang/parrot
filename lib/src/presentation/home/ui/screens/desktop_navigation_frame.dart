import 'dart:async';
import 'package:flutter_version_manager/src/core/core.dart';
import 'package:flutter_version_manager/src/core/router/route_configurations_desktop.dart';
import 'package:flutter_version_manager/src/presentation/home/data/utils/upgrader_config.dart';
import 'package:flutter_version_manager/src/presentation/presentation.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:upgrader/upgrader.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_status_bar/windows_status_bar_widget.dart';

class DesktopNavigationFrame extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DesktopNavigationFrame({
    super.key,
    required this.navigationShell,
  });

  @override
  State<DesktopNavigationFrame> createState() => _DesktopNavigationFrameState();
}

class _DesktopNavigationFrameState extends State<DesktopNavigationFrame>
    with WindowListener {
  Timer? _saveWindowsSizeTimer;

  // Detect when windows is changing size and save windows size
  @override
  void onWindowResize() async {
    // delay before save data
    if (_saveWindowsSizeTimer?.isActive ?? false) {
      _saveWindowsSizeTimer?.cancel();
    }
    _saveWindowsSizeTimer = Timer(const Duration(seconds: 10), () async {
      Size windowsSize = await WindowManager.instance.getSize();
      DebugLog.info('Height: ${windowsSize.height}');
      DebugLog.info('Width: ${windowsSize.width}');
      // Save windows size to setting
      final newSettings = Properties.instance.settings.copyWith(
          windowsWidth: windowsSize.width, windowsHeight: windowsSize.height);
      Properties.instance.saveSettings(newSettings);
    });
  }

  void _loadUpData() async {
    /// Increase count number to count the how many time user open app
    Properties.instance.saveSettings(Properties.instance.settings
        .copyWith(openAppCount: Properties.instance.settings.openAppCount + 1));
  }

  @override
  void initState() {
    super.initState();
    WindowManager.instance.addListener(this);
    // Other loading steps
    _loadUpData();
  }

  @override
  void dispose() {
    _saveWindowsSizeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpgradeAlert(
        showReleaseNotes: false,
        showIgnore: false,
        upgrader: UpgraderConfig.upgrader,
        child: Column(
          children: [
            if (isWindows)
              WindowsStatusBarWidget(
                backgroundColor: context.theme.scaffoldBackgroundColor,
                actions: [
                  SizedBox(
                      width: kToolbarHeight,
                      height: kToolbarHeight - 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          LocalDirectory.appLogo,
                        ),
                      )),
                  const Text(DefaultSettings.appShortName),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        goBranch(2);
                      },
                      icon: const Icon(FluentIcons.settings_16_regular)),
                ],
              ),
            Expanded(
              child: widget.navigationShell,
            ),
            Container(
              height: dcWindowsStatusBarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  //color: context.theme.colorScheme.surfaceContainer,
                  border: Border(
                      top: BorderSide(
                          color: context.theme.dividerColor.withOpacity(.3),
                          width: .3))),
              child: Opacity(
                opacity: .8,
                child: Row(
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          goToBugReport();
                        },
                        icon: Icon(
                          FluentIcons.bug_16_regular,
                          size: 18,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        label: Opacity(
                          opacity: .5,
                          child: Text(
                            'Report Issues'.i18n,
                            style: context.theme.textTheme.labelSmall,
                          ),
                        )),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        /// go to donation screen
                        goBranch(4);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Donate'.i18n,
                                style: context.theme.textTheme.labelSmall,
                              ),
                              4.width,
                              Icon(
                                FluentIcons.heart_12_regular,
                                color: context.theme.colorScheme.primary,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          goToStoreListing();
                        },
                        child: Opacity(
                          opacity: .5,
                          child: Text(
                            'Rate us'.i18n,
                            style: context.theme.textTheme.labelSmall,
                          ),
                        )),
                    IconButton(
                      onPressed: () {
                        goBranch(3);
                      },
                      icon: Icon(
                        FluentIcons.info_16_regular,
                        color: context.theme.colorScheme.onSurface,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
