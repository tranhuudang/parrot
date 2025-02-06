// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_version_manager/src/core/core.dart';
// import 'package:flutter_version_manager/src/presentation/home/data/model/downloaded_flutter_sdks.dart';
//
// import '../model/flutter_versions.dart';
//
//
// part 'main_home_event.dart';
// part 'main_home_state.dart';
//
// class MainHomeBloc extends Bloc<MainHomeEvent, MainHomeState> {
//   MainHomeBloc() : super(MainHomeState.initial()) {
//     on<InitializeHome>(_onInitializeHome);
//     on<CheckFvmInstallation>(_onCheckFvmInstallation);
//     on<FetchOnlineFlutterVersions>(_onFetchOnlineFlutterVersions);
//     on<DownloadFlutterVersion>(_onDownloadFlutterVersion);
//     on<FetchDownloadedFlutterVersions>(_onFetchDownloadedFlutterVersions);
//     on<SwitchFlutterVersion>(_onSwitchFlutterVersion);
//     on<SelectProjectPath>(_onSelectProjectPath);
//     on<InstallFvm>(_onInstallFvm);
//     on<SelectOnlineVersion>(_onSelectOnlineVersion);
//     on<SelectDownloadedVersion>(_onSelectDownloadedVersion);
//   }
//
//   final TextEditingController projectPathController = TextEditingController();
//
//   Future<void> _onInitializeHome(
//       InitializeHome event, Emitter<MainHomeState> emit) async {
//     add(CheckFvmInstallation());
//     add(FetchOnlineFlutterVersions());
//     add(FetchDownloadedFlutterVersions());
//   }
//
//   Future<void> _onCheckFvmInstallation(
//       CheckFvmInstallation event, Emitter<MainHomeState> emit) async {
//     try {
//       ProcessResult result = await Process.run('fvm', ['--version']);
//       emit(state.copyWith(fvmVersion: result.stdout.toString().trim()));
//     } catch (e) {
//       DebugLog.error(e.toString());
//     }
//   }
//
//   Future<void> _onFetchOnlineFlutterVersions(
//       FetchOnlineFlutterVersions event, Emitter<MainHomeState> emit) async {
//     try {
//       ProcessResult result = await Process.run('fvm', ['api', 'releases']);
//       if (result.exitCode == 0) {
//         String jsonString = result.stdout.toString();
//         jsonString = jsonString.substring(
//             jsonString.indexOf("["), jsonString.lastIndexOf("]") + 1);
//         List<dynamic> jsonData = json.decode(jsonString);
//         OnlineFlutterSDKVersions releases =
//         OnlineFlutterSDKVersions.fromJson(jsonData);
//         List<String> versions =
//         releases.versions.map((release) => release.version).toList();
//         emit(state.copyWith(
//           availableVersions: versions,
//           selectedOnlineVersion: versions.isNotEmpty ? versions.first : '',
//         ));
//       }
//     } catch (e) {
//       DebugLog.error("Error fetching Flutter versions: $e");
//     }
//   }
//
//   Future<void> _onDownloadFlutterVersion(
//       DownloadFlutterVersion event, Emitter<MainHomeState> emit) async {
//     if (state.selectedOnlineVersion.isEmpty) return;
//     try {
//       Process process =
//       await Process.start('fvm', ['install', state.selectedOnlineVersion]);
//
//       await for (var data in process.stdout.transform(utf8.decoder)) {
//         emit(state.copyWith(commandOutput: data));
//       }
//     } catch (e) {
//       DebugLog.error("Error: $e");
//     }
//   }
//
//
//   Future<void> _onFetchDownloadedFlutterVersions(
//       FetchDownloadedFlutterVersions event, Emitter<MainHomeState> emit) async {
//     try {
//       ProcessResult result = await Process.run('fvm', ['api', 'list']);
//       String jsonString = result.stdout.toString();
//       jsonString = jsonString.substring(
//           jsonString.indexOf("["), jsonString.lastIndexOf("]") + 1);
//       List<DownloadedFlutterSDK> downloadedFlutterSDKs =
//           DownloadedFlutterSDKs.fromJson(json.decode(jsonString)).sdks;
//       List<String> versions =
//       downloadedFlutterSDKs.map((sdk) => sdk.name).toList();
//       emit(state.copyWith(downloadedFlutterVersions: versions));
//     } catch (e) {
//       DebugLog.error("Error fetching Flutter versions: $e");
//     }
//   }
//
//   Future<void> _onSwitchFlutterVersion(
//       SwitchFlutterVersion event, Emitter<MainHomeState> emit) async {
//     if (state.selectedVersion.isEmpty) return;
//     try {
//       Process process = await Process.start(
//           'cmd', ['/c', 'echo y | fvm use ${state.selectedVersion}'],
//           workingDirectory: event.projectPath);
//
//       await for (var data in process.stdout.transform(utf8.decoder)) {
//         emit(state.copyWith(commandOutput: data));
//       }
//     } catch (e) {
//       DebugLog.error("Error: $e");
//     }
//   }
//
//
//   Future<void> _onInstallFvm(
//       InstallFvm event, Emitter<MainHomeState> emit) async {
//     try {
//       ProcessResult result = await Process.run(
//         'dart',
//         ['pub', 'global', 'activate', 'fvm'],
//         workingDirectory: projectPathController.text,
//         runInShell: true,
//       );
//       if (result.exitCode == 0) {
//         DebugLog.info("FVM installed successfully!");
//       }
//     } catch (e) {
//       DebugLog.error("Exception installing FVM: $e");
//     }
//   }
//
//   void _onSelectOnlineVersion(
//       SelectOnlineVersion event, Emitter<MainHomeState> emit) {
//     emit(state.copyWith(selectedOnlineVersion: event.version));
//   }
//
//   void _onSelectDownloadedVersion(
//       SelectDownloadedVersion event, Emitter<MainHomeState> emit) {
//     emit(state.copyWith(selectedVersion: event.version));
//   }
//
//   Future<void> _onSelectProjectPath(
//       SelectProjectPath event, Emitter<MainHomeState> emit) async {
//     String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
//     if (selectedDirectory != null) {
//       projectPathController.text = selectedDirectory;
//     }
//   }
// }
