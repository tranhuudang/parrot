import 'dart:io';

import 'package:flutter_version_manager/src/core/core.dart';
import 'package:flutter_version_manager/src/presentation/home/ui/widgets/main_home_body.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../presentation.dart';

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {


  @override
  void initState() {
    super.initState();
    _seekFeedback();
  }

  void _seekFeedback() async {
    final didRateApp = Properties.instance.settings.didRateApp;
    final openAppCount = Properties.instance.settings.openAppCount;
    DebugLog.info('Open App Count: $openAppCount');
    if ((!didRateApp && openAppCount != 0 && openAppCount % 2 == 0) ||
        (didRateApp && openAppCount % 50 == 0)) {
      await Future.delayed(const Duration(seconds: 2), () {
        context.showAlertDialog(
            actionButtonTitle: 'Feedback'.i18n,
            title: 'Help Us Improve'.i18n,
            content:
                "If something isn’t working as expected, we’d like to know. Share your feedback on how we can improve or let us know what you enjoy about our app."
                    .i18n,
            action: () {
              goToStoreListing();
              Properties.instance.saveSettings(
                  Properties.instance.settings.copyWith(didRateApp: true));
            });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(children: [
            Expanded(
              child: Container(
                height: 176,
                color: context.theme.colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: .3,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset('assets/flutter.png')),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            child: Text('${DateTime.now().year}.$appVersion'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ReleaseNotesView()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DefaultSettings.appName,
                                  style: context.theme.textTheme.headlineSmall,
                                ),
                                const SizedBox(width: 100, child: Divider()),
                                Text(
                                    'A user-friendly, robust, and adaptable tool for managing multiple Flutter SDK versions.'
                                        .i18n)
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildIconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.github,
                                    size: 16,
                                  ),
                                  url:
                                      'https://github.com/tranhuudang/flutter_version_manager'),
                              _buildIconButton(
                                  icon: const Icon(
                                    Icons.mail,
                                    size: 20,
                                  ),
                                  url: 'mailto:dt148f148@gmail.com'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
          const Divider(
            height: 0,
          ),
          Row(
            children: [
              Expanded(
                child: DashboardShape(
                  backgroundColor:
                      context.theme.colorScheme.surfaceContainerHigh,
                  textColor: context.theme.colorScheme.onSurface,
                ),
              ),
              DashboardShape(
                backgroundColor: context.theme.colorScheme.primary,
                textColor: context.theme.colorScheme.onPrimary,
              ),
              DashboardShape(
                backgroundColor: context.theme.colorScheme.onSurface,
                textColor: context.theme.colorScheme.onPrimary,
              ),
            ],
          ),
          // Control Section
          Expanded(child: MainHomeBody()),
        ],
      ),
    );
  }
}



class DashboardShape extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Widget? child;
  const DashboardShape({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 86,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

Widget _buildIconButton({required Icon icon, required String url}) {
  return IconButton(
      onPressed: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $uri');
        }
      },
      icon: icon);
}
