import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_version_manager/src/core/core.dart';
import 'package:flutter_version_manager/src/core/utils/launchUrl.dart';
import 'package:flutter_version_manager/src/presentation/home/data/notifier/main_home_state.dart';
import 'package:flutter_version_manager/src/presentation/home/ui/screens/install_fvm_instruction.dart';
import 'package:flutter_version_manager/src/presentation/home/ui/widgets/platform_selector.dart';
import '../../../presentation.dart';
import '../../data/notifier/main_home_notifier.dart';
import 'control_project_button.dart';

class MainHomeBody extends ConsumerWidget {
  const MainHomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainHomeProvider);
    final notifier = ref.read(mainHomeProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        4.height,
        // FVM CLI version
        buildFVMCLIVersion(state, context, notifier),

        Expanded(
            child: IgnorePointer(
          ignoring: state.fvmVersion.isEmpty ? true : false,
          child: Opacity(
            opacity: state.fvmVersion.isEmpty ? .5 : 1,
            child: Column(
              children: [
                buildAvailableFlutterSDKreleases(state, notifier),
                buildTargetFlutterProjectSelection(notifier, context),
                if (state.projectPath.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        buildSelectFlutterVersionToSwitch(state, notifier),
                        8.height,
                        buildProjectRunningControl(state, notifier),
                      ],
                    ),
                  )
                ],
                8.height,
                buildConsole(context, state),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Expanded buildConsole(BuildContext context, MainHomeState state) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(8.0),
        decoration:
            BoxDecoration(color: context.theme.colorScheme.surfaceContainer),
        child: ListView(reverse: true, children: state.commandOutput.toList()),
      ),
    );
  }

  Row buildTargetFlutterProjectSelection(
      MainHomeNotifier notifier, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Target Flutter Project:'.i18n),
        8.width,
        Expanded(
          child: TextFormField(
            enabled: false,
            controller: notifier.projectPathController,
            readOnly: true,
            style: TextStyle(color: context.theme.colorScheme.primary),
            decoration: InputDecoration(
              hintText: 'Selected Flutter Project Path'.i18n,
              border: InputBorder.none,
            ),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(FluentIcons.folder_16_regular),
          onPressed: () => notifier.selectProjectPath(),
          label: Text('Select Project Path'.i18n),
        ),
      ],
    );
  }

  Row buildProjectRunningControl(
      MainHomeState state, MainHomeNotifier notifier) {
    return Row(
      children: [
        const Icon(
          FluentIcons.circle_16_regular,
          size: 14,
        ),
        16.width,
        Text(state.projectPath
            .substring(state.projectPath.lastIndexOf('\\') + 1)),
        16.width,
        const PlatformSelector(),
        16.width,
        if (state.isGettingAvailableDevices) ...[
          const SizedBox(
              height: 20, width: 20, child: CircularProgressIndicator()),
          16.width,
        ],
        ControlProjectButton(
          backgroundColor: const Color(0xFF66BB6A),
          enabled: !state.isRunning,
          icon: const Icon(
            FluentIcons.play_16_regular,
            size: 16,
          ),
          onPressed: () {
            notifier.runFlutterProject();
          },
        ),
        8.width,
        ControlProjectButton(
          backgroundColor: const Color(0xFFF50057),
          enabled: state.isRunning,
          icon: const Icon(
            FluentIcons.stop_16_regular,
            size: 16,
          ),
          onPressed: () {
            notifier.stopFlutterProject();
          },
        ),
        8.width,
        ControlProjectButton(
          backgroundColor: Colors.orange,
          enabled: state.isRunning,
          icon: const Icon(
            FluentIcons.arrow_sync_24_regular,
            size: 16,
          ),
          onPressed: () {
            notifier.hotReloadFlutterProject();
          },
        ),
        8.width,
        IconButton(
          onPressed: () => notifier.refreshAvailableDevices(),
          icon: const Icon(FluentIcons.arrow_sync_16_regular),
        ),
      ],
    );
  }

  Row buildSelectFlutterVersionToSwitch(
      MainHomeState state, MainHomeNotifier notifier) {
    return Row(
      children: [
        const Icon(
          FluentIcons.circle_16_regular,
          size: 14,
        ),
        16.width,
        Text("Select new Flutter version to switch:".i18n),
        8.width,
        RoundedDottedDropdownButton<String>(
          value:
              state.selectedVersion.isNotEmpty ? state.selectedVersion : null,
          hint: Text("Select Flutter Version".i18n),
          items: state.downloadedFlutterVersions
              .map((version) => DropdownMenuItem(
                    value: version,
                    child: Text(version),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              notifier.selectDownloadedVersion(value);
            }
          },
        ),
        8.width,
        IconButton(
          onPressed: () => notifier.fetchDownloadedFlutterVersions(),
          icon: const Icon(FluentIcons.arrow_sync_16_regular),
        ),
        const Spacer(),
        8.width,
        ElevatedButton.icon(
          icon: const Icon(FluentIcons.arrow_shuffle_16_regular),
          onPressed: state.isSwitching
              ? null
              : () => notifier
                  .switchFlutterVersion(notifier.projectPathController.text),
          label: state.isSwitching
              ? const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator())
              : Text("Switch".i18n),
        ),
      ],
    );
  }

  Row buildAvailableFlutterSDKreleases(
      MainHomeState state, MainHomeNotifier notifier) {
    return Row(
      children: [
        Text("${'Available Flutter SDK releases:'.i18n} "),
        8.width,
        RoundedDottedDropdownButton<String>(
          value: state.selectedOnlineVersion.isNotEmpty
              ? state.selectedOnlineVersion
              : null,
          hint: Text("Select Flutter Version".i18n),
          items: state.availableVersions
              .map((version) => DropdownMenuItem(
                    value: version,
                    child: Text(version),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              notifier.selectOnlineVersion(value);
            }
          },
        ),
        8.width,
        IconButton(
          onPressed: () => notifier.fetchOnlineFlutterVersions(),
          icon: const Icon(FluentIcons.arrow_sync_16_regular),
        ),
        const Spacer(),
        8.width,
        ElevatedButton.icon(
          icon: const Icon(FluentIcons.arrow_download_16_regular),
          onPressed: state.isDownloading
              ? null
              : () => notifier.downloadFlutterVersion(),
          label: state.isDownloading
              ? const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator())
              : Text("Download".i18n),
        ),
      ],
    );
  }

  Column buildFVMCLIVersion(
      MainHomeState state, BuildContext context, MainHomeNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('FVM CLI version:'.i18n),
            8.width,
            state.fvmVersion.isEmpty
                ? FilledButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InstallFVMScreen()));
                    },
                    child: Text('Install FVM CLI'.i18n),
                  )
                : Text(state.fvmVersion),
            8.width,
            IconButton(
              onPressed: () => notifier.checkFvmInstallation(),
              icon: const Icon(FluentIcons.arrow_sync_16_regular),
            ),
            const Spacer(),
            8.width,
            TextButton(
              onPressed: () {
                openUrl('https://github.com/leoafarias/fvm/releases');
              },
              child: Text("What's new?".i18n),
            ),
          ],
        ),
        if (state.fvmVersion.isEmpty) ...[
          Text(
            '*You must install FVM CLI to use this app.'.i18n,
            style:
                context.theme.textTheme.labelSmall?.copyWith(color: Colors.red),
          ),
          8.height,
        ],
      ],
    );
  }
}
