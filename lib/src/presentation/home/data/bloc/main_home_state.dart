// part of 'main_home_bloc.dart';
//
// class MainHomeState {
//   final String selectedVersion;
//   final String selectedOnlineVersion;
//   final List<String> downloadedFlutterVersions;
//   final String commandOutput;
//   final List<String> availableVersions;
//   final String fvmVersion;
//
//   MainHomeState({
//     required this.selectedVersion,
//     required this.selectedOnlineVersion,
//     required this.downloadedFlutterVersions,
//     required this.commandOutput,
//     required this.availableVersions,
//     required this.fvmVersion,
//   });
//
//   factory MainHomeState.initial() {
//     return MainHomeState(
//       selectedVersion: '',
//       selectedOnlineVersion: '',
//       downloadedFlutterVersions: [],
//       commandOutput: "Command output will appear here...",
//       availableVersions: [],
//       fvmVersion: '',
//     );
//   }
//
//   MainHomeState copyWith({
//     String? selectedVersion,
//     String? selectedOnlineVersion,
//     List<String>? downloadedFlutterVersions,
//     String? commandOutput,
//     List<String>? availableVersions,
//     String? fvmVersion,
//   }) {
//     return MainHomeState(
//       selectedVersion: selectedVersion ?? this.selectedVersion,
//       selectedOnlineVersion: selectedOnlineVersion ?? this.selectedOnlineVersion,
//       downloadedFlutterVersions: downloadedFlutterVersions ?? this.downloadedFlutterVersions,
//       commandOutput: commandOutput ?? this.commandOutput,
//       availableVersions: availableVersions ?? this.availableVersions,
//       fvmVersion: fvmVersion ?? this.fvmVersion,
//     );
//   }
// }
