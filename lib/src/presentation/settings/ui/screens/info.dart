import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_version_manager/src/core/utils/launchUrl.dart';
import 'package:flutter_version_manager/src/presentation/donation/donation_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_version_manager/src/presentation/presentation.dart';
import 'package:flutter_version_manager/src/core/core.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: CustomTitle(
            title: 'About'.i18n, iconData: FluentIcons.info_12_regular),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAboutSection(context),
          _buildLicensesSection(context),
          _buildPrivacyPolicySection(context),
          30.height,
        ],
      ),
    );
  }

  // Extract About section to improve readability
  Widget _buildAboutSection(BuildContext context) {
    return Section(
      title: 'About'.i18n,
      children: [
        Column(
          children: [
            const Image(
              image: AssetImage(LocalDirectory.appLogo),
              height: 90,
            ),
            8.height,
            Text(
              DefaultSettings.appTitleDescription,
              style: context.theme.textTheme.titleLarge?.copyWith(
                  color: context.theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        8.height,
        TextButton(
          child: Text('${DateTime.now().year}.$appVersion'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReleaseNotesView()));
          },
        ),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
                icon: const Icon(
                  FontAwesomeIcons.github,
                  size: 20,
                ),
                url: 'https://github.com/tranhuudang'),
            _buildIconButton(
                icon: const Icon(Icons.mail),
                url: 'mailto:dt148f148@gmail.com'),
          ],
        ),
        8.height,
        Text(
          "© ${DateTime.now().year} Tran Huu Dang. ${"All rights reserved.".i18n}",
          style: context.theme.textTheme.bodyMedium
              ?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  // Extract Licenses section
  Widget _buildLicensesSection(BuildContext context) {
    return Section(
      title: 'Licenses'.i18n,
      isExpand: false,
      children: [
        Text(
          'DescriptionTextForLicenses'.i18n,
          style: context.theme.textTheme.bodyMedium
              ?.copyWith(color: context.theme.colorScheme.onSurface),
        ),
        8.height,
        FilledButton.tonal(
            onPressed: () {
              showLicensePage(context: context);
            },
            child: Text('Licenses'.i18n)),
      ],
    );
  }

  // Extract Privacy Policy section
  Widget _buildPrivacyPolicySection(BuildContext context) {
    return Section(
      title: 'Privacy Policy'.i18n,
      crossAxisAlignment: CrossAxisAlignment.start,
      isExpand: false,
      children: [
        Text(
          'DesciptionTextForPrivacyPolicy'.i18n,
          style: context.theme.textTheme.bodyMedium
              ?.copyWith(color: context.theme.colorScheme.onSurface),
        ),
        4.height,
        Text(
          'For more information about our privacy policy, please visit:'.i18n,
          style: context.theme.textTheme.bodyMedium
              ?.copyWith(color: context.theme.colorScheme.onSurface),
        ),
        8.height,
        Center(
          child: _buildFilledButton(
              url: OnlineDirectory.privacyPolicyURL,
              text: 'Privacy Policy'.i18n),
        )
      ],
    );
  }

  // Helper function to create IconButtons with URL launching
  Widget _buildIconButton({required Icon icon, required String url}) {
    return IconButton(
        onPressed: ()  {
          openUrl(url);
        },
        icon: icon);
  }

  // Helper function to create FilledButtons with URL launching
  Widget _buildFilledButton({required String url, required String text}) {
    return FilledButton.tonal(
        onPressed: () async {
          openUrl(url);
        },
        child: Text(text));
  }
}
