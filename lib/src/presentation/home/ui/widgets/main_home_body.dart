//
// import 'package:fluentui_system_icons/fluentui_system_icons.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_version_manager/src/core/core.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../data/bloc/main_home_bloc.dart';
//
// class MainHomeBody extends StatelessWidget {
//   const MainHomeBody({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => MainHomeBloc()..add(InitializeHome()),
//       child: BlocBuilder<MainHomeBloc, MainHomeState>(
//         builder: (context, state) {
//           final bloc = context.read<MainHomeBloc>();
//           return Column(
//             children: [
//               Row(
//                 children: [
//                   const Text('FVM version:'),
//                   8.width,
//                   state.fvmVersion.isEmpty
//                       ? FilledButton(
//                       onPressed: () => bloc.add(InstallFvm()),
//                       child: const Text('Install FVM CLI'))
//                       : Text(state.fvmVersion),
//                   8.width,
//                   IconButton(
//                       onPressed: () => bloc.add(CheckFvmInstallation()),
//                       icon: const Icon(FluentIcons.arrow_sync_16_regular)),
//                   const Spacer(),
//                   8.width,
//                   TextButton(onPressed: () {}, child: const Text("What's new?")),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Text('Available Flutter SDK releases: '),
//                   8.width,
//                   DropdownButton<String>(
//                     value: state.selectedOnlineVersion.isNotEmpty
//                         ? state.selectedOnlineVersion
//                         : null,
//                     hint: const Text("Select Flutter Version"),
//                     items: state.availableVersions
//                         .map((version) => DropdownMenuItem(
//                       value: version,
//                       child: Text(version),
//                     ))
//                         .toList(),
//                     onChanged: (value) {
//                       bloc.add(SelectOnlineVersion(value!));
//                     },
//                   ),
//                   8.width,
//                   IconButton(
//                       onPressed: () => bloc.add(FetchOnlineFlutterVersions()),
//                       icon: const Icon(FluentIcons.arrow_sync_16_regular)),
//                   const Spacer(),
//                   8.width,
//                   ElevatedButton(
//                     onPressed: () => bloc.add(DownloadFlutterVersion()),
//                     child: const Text("Download"),
//                   ),
//                 ],
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Text('Target Flutter Project:'),
//                   8.width,
//                   Expanded(
//                     child: TextFormField(
//                       enabled: false,
//                       controller: bloc.projectPathController,
//                       readOnly: true,
//                       decoration: const InputDecoration(
//                         hintText: 'Selected Flutter Project Path',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => bloc.add(SelectProjectPath()),
//                     child: const Text('Select Project Path'),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Text("Select new Flutter version to switch:"),
//                   8.width,
//                   DropdownButton<String>(
//                     value:
//                     state.selectedVersion.isNotEmpty ? state.selectedVersion : null,
//                     hint: const Text("Select Flutter Version"),
//                     items: state.downloadedFlutterVersions
//                         .map((version) => DropdownMenuItem(
//                       value: version,
//                       child: Text(version),
//                     ))
//                         .toList(),
//                     onChanged: (value) {
//                       bloc.add(SelectDownloadedVersion(value!));
//                     },
//                   ),
//                   8.width,
//                   IconButton(
//                       onPressed: () => bloc.add(FetchDownloadedFlutterVersions()),
//                       icon: const Icon(FluentIcons.arrow_sync_16_regular)),
//                   const Spacer(),
//                   8.width,
//                   ElevatedButton(
//                     onPressed: () =>
//                         bloc.add(SwitchFlutterVersion(bloc.projectPathController.text)),
//                     child: const Text("Switch"),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   padding: const EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                       color: context.theme.colorScheme.surfaceContainer),
//                   child: SingleChildScrollView(
//                       child: Text(state.commandOutput,
//                           style: GoogleFonts.inconsolata())),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
