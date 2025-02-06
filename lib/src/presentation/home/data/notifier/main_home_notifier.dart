import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../model/downloaded_flutter_sdks.dart';
import '../model/flutter_versions.dart';
import 'main_home_state.dart';
final mainHomeProvider =
StateNotifierProvider<MainHomeNotifier, MainHomeState>((ref) {
  return MainHomeNotifier();
});
class MainHomeNotifier extends StateNotifier<MainHomeState> {
  MainHomeNotifier() : super(MainHomeState.initial()) {
    initializeHome();
  }

  final TextEditingController projectPathController = TextEditingController();

  // Initialize the home page by checking FVM installation and fetching versions
  Future<void> initializeHome() async {
    await checkFvmInstallation();
    await fetchOnlineFlutterVersions();
    await fetchDownloadedFlutterVersions();
  }

  // Check if FVM is installed and update the state
  Future<void> checkFvmInstallation() async {
    state = state.copyWith(isCheckingFvm: true); // Update loading state
    try {
      ProcessResult result = await Process.run('fvm', ['--version']);
      state = state.copyWith(
        fvmVersion: result.stdout.toString().trim(),
        isCheckingFvm: false, // Set loading state to false
      );
    } catch (e) {
      DebugLog.error(e.toString());
      state =
          state.copyWith(isCheckingFvm: false); // Set loading state to false
    }
  }

  // Fetch online Flutter SDK versions
  Future<void> fetchOnlineFlutterVersions() async {
    state = state.copyWith(isFetchingVersions: true); // Update loading state
    try {
      ProcessResult result = await Process.run('fvm', ['api', 'releases']);
      if (result.exitCode == 0) {
        String jsonString = result.stdout.toString();
        jsonString = jsonString.substring(
            jsonString.indexOf("["), jsonString.lastIndexOf("]") + 1);
        List<dynamic> jsonData = json.decode(jsonString);
        OnlineFlutterSDKVersions releases =
            OnlineFlutterSDKVersions.fromJson(jsonData);
        List<String> versions =
            releases.versions.map((release) => release.version).toList();
        state = state.copyWith(
          availableVersions: versions,
          selectedOnlineVersion: versions.isNotEmpty ? versions.first : '',
          isFetchingVersions: false, // Set loading state to false
        );
      }
    } catch (e) {
      DebugLog.error("Error fetching Flutter versions: $e");
      state = state.copyWith(
          isFetchingVersions: false); // Set loading state to false
    }
  }

  // Download the selected Flutter version
  Future<void> downloadFlutterVersion() async {
    if (state.selectedOnlineVersion.isEmpty) return;
    state = state.copyWith(isDownloading: true); // Update loading state
    try {
      Process process =
          await Process.start('fvm', ['install', state.selectedOnlineVersion]);
      process.stdout.transform(utf8.decoder).listen((data) {
        state = state.copyWith(commandOutput: data);
      });
      process.exitCode.then((exitCode) {
        if (exitCode == 0) {
          state = state.copyWith(
              isDownloading: false); // Set loading state to false
        } else {
          state = state.copyWith(
              isDownloading: false); // Set loading state to false
        }
      });
    } catch (e) {
      DebugLog.error("Error: $e");
      state =
          state.copyWith(isDownloading: false); // Set loading state to false
    }
  }

  // Fetch the downloaded Flutter versions
  Future<void> fetchDownloadedFlutterVersions() async {
    state = state.copyWith(isFetchingDownloaded: true); // Update loading state
    try {
      ProcessResult result = await Process.run('fvm', ['api', 'list']);
      String jsonString = result.stdout.toString();
      jsonString = jsonString.substring(
          jsonString.indexOf("["), jsonString.lastIndexOf("]") + 1);
      List<DownloadedFlutterSDK> downloadedFlutterSDKs =
          DownloadedFlutterSDKs.fromJson(json.decode(jsonString)).sdks;
      List<String> versions =
          downloadedFlutterSDKs.map((sdk) => sdk.name).toList();
      DebugLog.info(versions.toString());

      state = state.copyWith(
        downloadedFlutterVersions: versions,
        isFetchingDownloaded: false, // Set loading state to false
      );
    } catch (e) {
      DebugLog.error("Error fetching Flutter versions: $e");
      state = state.copyWith(
          isFetchingDownloaded: false); // Set loading state to false
    }
  }

  // Switch the Flutter version for the project
  Future<void> switchFlutterVersion(String projectPath) async {
    if (state.selectedVersion.isEmpty) return;
    state = state.copyWith(isSwitching: true); // Update loading state
    try {
      Process process = await Process.start(
          'cmd', ['/c', 'echo y | fvm use ${state.selectedVersion}'],
          workingDirectory: projectPath);
      process.stdout.transform(utf8.decoder).listen((data) {
        state = state.copyWith(commandOutput: data);
      });
      process.exitCode.then((exitCode) {
        state =
            state.copyWith(isSwitching: false); // Set loading state to false
      });
    } catch (e) {
      DebugLog.error("Error: $e");
      state = state.copyWith(isSwitching: false); // Set loading state to false
    }
  }

  // Install FVM if not already installed
  Future<void> installFvm() async {
    state = state.copyWith(isInstallingFvm: true); // Update loading state
    try {
      ProcessResult result = await Process.run(
        'dart',
        ['pub', 'global', 'activate', 'fvm'],
        workingDirectory: projectPathController.text,
        runInShell: true,
      );
      if (result.exitCode == 0) {
        DebugLog.info("FVM installed successfully!");
        state = state.copyWith(
            isInstallingFvm: false); // Set loading state to false
      }
    } catch (e) {
      DebugLog.error("Exception installing FVM: $e");
      state =
          state.copyWith(isInstallingFvm: false); // Set loading state to false
    }
  }

  // Select the online Flutter version
  void selectOnlineVersion(String version) {
    if (state.availableVersions.contains(version)) {
      state = state.copyWith(selectedOnlineVersion: version);
    }
  }

  // Select the downloaded Flutter version
  void selectDownloadedVersion(String version) {
    state = state.copyWith(selectedVersion: version);
  }

  // Open file picker to select project directory
  Future<void> selectProjectPath() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      projectPathController.text = selectedDirectory;
    }
  }
}
