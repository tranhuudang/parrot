import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_version_manager/src/core/core.dart';
import 'package:flutter_version_manager/src/core/utils/launchUrl.dart';
import 'package:flutter_version_manager/src/presentation/home/ui/screens/install_fvm_instruction.dart';
import 'package:flutter_version_manager/src/presentation/home/ui/widgets/platform_selector.dart';
import '../../data/notifier/main_home_notifier.dart';

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
        Row(
          children: [
            const Text('FVM version:'),
            8.width,
            state.fvmVersion.isEmpty
                ? FilledButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InstallFVMScreen()));
                    },
                    child: const Text('Install FVM CLI'),
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
              child: const Text("What's new?"),
            ),
          ],
        ),
        if (state.fvmVersion.isEmpty) ...[
          8.height,
          Text(
            '*You must install FVM CLI to use this app.',
            style:
                context.theme.textTheme.labelSmall?.copyWith(color: Colors.red),
          ),
        ],
        Expanded(
            child: IgnorePointer(
          ignoring: state.fvmVersion.isEmpty ? true : false,
          child: Opacity(
            opacity: state.fvmVersion.isEmpty ? .5 : 1,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Available Flutter SDK releases: '),
                    8.width,
                    DropdownButton<String>(
                      value: state.selectedOnlineVersion.isNotEmpty
                          ? state.selectedOnlineVersion
                          : null,
                      hint: const Text("Select Flutter Version"),
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
                    ElevatedButton(
                      onPressed: state.isDownloading
                          ? null
                          : () => notifier.downloadFlutterVersion(),
                      child: state.isDownloading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator())
                          : const Text("Download"),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Target Flutter Project:'),
                    8.width,
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        controller: notifier.projectPathController,
                        readOnly: true,
                        style: TextStyle(color: context.theme.colorScheme.primary),
                        decoration: const InputDecoration(
                          hintText: 'Selected Flutter Project Path',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => notifier.selectProjectPath(),
                      child: const Text('Select Project Path'),
                    ),
                  ],
                ),
                if (state.projectPath.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(FluentIcons.circle_16_regular, size: 14,),
                            16.width,
                            const Text("Select new Flutter version to switch:"),
                            8.width,
                            DropdownButton<String>(
                              value: state.selectedVersion.isNotEmpty
                                  ? state.selectedVersion
                                  : null,
                              hint: const Text("Select Flutter Version"),
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
                              onPressed: () =>
                                  notifier.fetchDownloadedFlutterVersions(),
                              icon: const Icon(FluentIcons.arrow_sync_16_regular),
                            ),
                            const Spacer(),
                            8.width,
                            ElevatedButton(
                              onPressed: state.isSwitching
                                  ? null
                                  : () => notifier.switchFlutterVersion(
                                      notifier.projectPathController.text),
                              child: state.isSwitching
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator())
                                  : const Text("Switch"),
                            ),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            const Icon(FluentIcons.circle_16_regular, size: 14,),
                            16.width,
                            Text(state.projectPath.substring(state.projectPath.lastIndexOf('\\')+1)),
                            16.width,
                            const PlatformSelector(),
                            16.width,
                            Opacity(
                              opacity: !state.isRunning ? 1: .5,
                              child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(left: 7, right: 9, bottom: 8, top: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xFF66BB6A)
                                  ),
                                  child: const Icon(
                                    FluentIcons.play_16_regular, size: 16,
                                  ),
                                ),
                                onTap: () {
                                  notifier.runFlutterProject();
                                },
                              ),
                            ),
                            8.width,
                            Opacity(
                              opacity: state.isRunning ? 1: .5,
                              child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xFFF50057)
                                  ),
                                  child: const Icon(
                                    FluentIcons.stop_16_regular, size: 16,
                                  ),
                                ),
                                onTap: () {
                                  notifier.stopFlutterProject();
                                },
                              ),
                            ),
                            8.width,
                              Opacity(
                                opacity: state.isRunning ? 1: .5,
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.orange
                                    ),
                                    child: const Icon(
                                      FluentIcons.arrow_sync_24_regular, size: 16,
                                    ),
                                  ),
                                onTap: () {
                                  notifier.hotReloadFlutterProject();
                                },
                                                            ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )

                ],
                8.height,
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: context.theme.colorScheme.surfaceContainer),
                    child: ListView(
                        reverse: true, children: state.commandOutput.toList()),
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}
