import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_version_manager/src/core/core.dart';
import 'package:flutter_version_manager/src/core/utils/launchUrl.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../donation/donation_screen.dart';
import '../../../presentation.dart';

class InstallFVMScreen extends StatelessWidget {
  const InstallFVMScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: CustomTitle(
            title: 'Install FVM CLI on Windows'.i18n,
            iconData: FluentIcons.code_16_regular),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Follow these steps to install FVM on your Windows machine:',
              ),
              const SizedBox(height: 20),
              _buildStep(
                context,
                'Step 1: Install Chocolatey (if you don\'t have it)',
                'Run the following command in your PowerShell (as Administrator):',
                '''Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))''',
              ),
              const SizedBox(height: 20),
              _buildStep(
                context,
                'Step 2: Install FVM using Chocolatey',
                'Run this command to install FVM:',
                'choco install fvm',
              ),
              const SizedBox(height: 20),
              DottedBorder(
                dashPattern: const [4, 4],
                borderType: BorderType.RRect,
                strokeWidth: 1,
                radius: const Radius.circular(5),
                color: context.theme.dividerColor,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'For for information about how to install FVM, please visit:'
                            .i18n,
                      ),
                      4.height,
                      Row(
                        children: [
                          CachedNetworkSVGImage(
                            'https://fvm.app/assets/logo.svg',
                            placeholder: const CircularProgressIndicator(
                                color: Colors.green),
                            errorWidget:
                                const Icon(Icons.error, color: Colors.red),
                            width: 24.0,
                            height: 24.0,
                            fadeDuration: const Duration(milliseconds: 500),
                          ),
                          8.width,
                          InkWell(
                            onTap: () {
                              openUrl(
                                  'https://fvm.app/documentation/getting-started/installation');
                            },
                            child: Text(
                              'FVM CLI Installation'.i18n,
                              style: TextStyle(
                                color: context.theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, String title, String description, String command) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(description),
        const SizedBox(height: 8),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: context.theme.colorScheme.surfaceContainer,
            ),
            child: SelectableText(command)),
        8.height,
        _buildCopyButton(context, command),
      ],
    );
  }

  Widget _buildCopyButton(BuildContext context, String command) {
    return ElevatedButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: command));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Command copied to clipboard')),
        );
      },
      child: const Text('Copy Command'),
    );
  }
}
