import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_version_manager/src/core/core.dart';
import 'package:flutter_version_manager/src/presentation/home/data/model/downloaded_flutter_sdks.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/flutter_versions.dart';

class MainHomeBody extends StatefulWidget {
  const MainHomeBody({super.key});

  @override
  State<MainHomeBody> createState() => _MainHomeBodyState();
}

class _MainHomeBodyState extends State<MainHomeBody> {
  String _selectedVersion = '';
  String _selectedOnlineVersion = '';
  List<String> _downloadedFlutterVersions = [];
  String _commandOutput = "Command output will appear here...";
  List<String> _availableVersions = [];
  String _fvmVersion = '';

  @override
  void initState() {
    super.initState();
    _checkFvmInstallation();
    _fetchOnlineFlutterVersions();
    _fetchDownloadedFlutterVersions();
  }

  Future<void> _checkFvmInstallation() async {
    try {
      ProcessResult result = await Process.run(
        'fvm',
        ['--version'],
      );
      setState(() {
        _fvmVersion = result.stdout.toString().trim();
      });
      DebugLog.info(_fvmVersion);
    } catch (e) {
      DebugLog.error(e.toString());
    }
  }

  /// Fetch available Flutter versions from `fvm api releases`
  Future<void> _fetchOnlineFlutterVersions() async {
    try {
      // Run the fvm api releases command and capture the output
      ProcessResult result = await Process.run('fvm', ['api', 'releases']);

      if (result.exitCode == 0) {
        // Decode the JSON string into a Dart object
        String jsonString = result.stdout.toString();
        // The result contain some weird data, this bellow code was meant to only get those necessary
        jsonString = jsonString.substring(
            jsonString.indexOf("["), jsonString.lastIndexOf("]") + 1);
        // Decode the JSON into FlutterReleases object using fromJson
        List<dynamic> jsonData = json.decode(jsonString);
        OnlineFlutterSDKVersions releases =
            OnlineFlutterSDKVersions.fromJson(jsonData);

        // Extract the version information from the 'versions' list
        List<String> versions = [];
        for (OnlineFlutterSDK release in releases.versions) {
          versions.add(release.version);
        }

        setState(() {
          _availableVersions = versions;

          _selectedOnlineVersion = versions.isNotEmpty ? versions.first : '';
        });

        print('here');
        print(_availableVersions);
      } else {
        setState(() {
          _commandOutput +=
              "Error fetching Flutter versions --: ${result.stderr}" + "\n";
        });
      }
    } catch (e) {
      setState(() {
        _commandOutput = "Error fetching Flutter versions 2: $e";
        print(_commandOutput);
      });
    }
  }

  /// Install selected Flutter version via FVM
  Future<void> _downloadFlutterVersion() async {
    if (_selectedOnlineVersion.isEmpty) return;

    setState(() {
      _commandOutput += "Installing Flutter $_selectedOnlineVersion..." + '\n';
    });

    try {
      Process process =
          await Process.start('fvm', ['install', _selectedOnlineVersion]);

      process.stdout.transform(utf8.decoder).listen((data) {
        setState(() {
          _commandOutput = data;
        });
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        setState(() {
          _commandOutput += "Error: $data" + '\n';
        });
      });

      await process.exitCode;
      setState(() {
        _commandOutput +=
            "Flutter $_selectedOnlineVersion installed successfully!" + '\n';
      });
    } catch (e) {
      setState(() {
        _commandOutput += "Error: $e" + '\n';
      });
    }
  }

  Future<void> _fetchDownloadedFlutterVersions() async {
    try {
      ProcessResult result = await Process.run('fvm', ['api', 'list']);
      // The result contain some weird data, this bellow code was meant to only get those necessary
      String jsonString = result.stdout.toString();
      jsonString = jsonString.substring(
          jsonString.indexOf("["), jsonString.lastIndexOf("]") + 1);

      List<DownloadedFlutterSDK> downloadedFlutterSDKs =
          DownloadedFlutterSDKs.fromJson(json.decode(jsonString)).sdks;

      List<String> versions = [];
      for (DownloadedFlutterSDK sdk in downloadedFlutterSDKs) {
        versions.add(sdk.name);
      }

      setState(() {
        _downloadedFlutterVersions = versions;
      });

      print(versions);
    } catch (e) {
      setState(() {
        _commandOutput = "Error fetching Flutter versions: $e";
      });
    }
  }

  Future<void> _switchFlutterVersion(String projectPath) async {
    if (_selectedVersion.isEmpty) return;

    setState(() {
      _commandOutput = "Switching to Flutter $_selectedVersion...";
    });

    try {
      Process process = await Process.start(
          'cmd', ['/c', 'echo y | fvm use $_selectedVersion'],
          workingDirectory: projectPath);

      process.stdout.transform(utf8.decoder).listen((data) {
        setState(() {
          String cleanedData = data.replaceAll(RegExp(r'[^\x20-\x7E]'), '');
          _commandOutput += cleanedData + '\n';
        });
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        setState(() {
          _commandOutput += "Error: $data" + '\n';
        });
      });

      await process.exitCode;
    } catch (e) {
      setState(() {
        _commandOutput = "Error: $e";
      });
    }
  }

  Future<void> installFvm(String projectPath) async {
    try {
      _commandOutput += "Installing FVM..." + "\n";

      // Run the command to install fvm globally
      ProcessResult result = await Process.run(
        'dart',
        ['pub', 'global', 'activate', 'fvm'],
        workingDirectory: projectPath,
        runInShell:
            true, // Ensures it runs properly in different OS environments
      );

      if (result.exitCode == 0) {
        _commandOutput += "FVM installed successfully!" + "\n";
        print(result.stdout);
      } else {
        _commandOutput += "Error installing FVM: ${result.stderr}" + "\n";
      }
    } catch (e) {
      print("Exception occurred while installing FVM: $e");
    }
  }

  TextEditingController _projectPathController = TextEditingController();

  Future<void> _selectPath() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _projectPathController.text = selectedDirectory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Install FVM
        Row(
          children: [
            Text('FVM version:'),
            8.width,
            _fvmVersion.isEmpty
                ? FilledButton(
                    onPressed: () => installFvm(_projectPathController.text),
                    child: Text('Install FVM CLI'))
                : Text(_fvmVersion),
            8.width,
            IconButton(
                onPressed: () {
                  _checkFvmInstallation();
                },
                icon: Icon(FluentIcons.arrow_sync_16_regular)),
            Spacer(),
            8.width,
            TextButton(onPressed: () {}, child: Text("What's new?")),
          ],
        ),

        /// Download online SDKs
        Row(
          children: [
            Text('Available Flutter SDK releases: '),
            8.width,
            DropdownButton<String>(
              value: _selectedOnlineVersion.isNotEmpty
                  ? _selectedOnlineVersion
                  : null,
              hint: const Text("Select Flutter Version"),
              items: _availableVersions
                  .map((version) => DropdownMenuItem(
                        value: version,
                        child: Text(version),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOnlineVersion = value!;
                });
              },
            ),
            8.width,
            IconButton(
                onPressed: () {
                  _fetchOnlineFlutterVersions();
                },
                icon: Icon(FluentIcons.arrow_sync_16_regular)),
            Spacer(),
            8.width,
            ElevatedButton(
              onPressed: () => _downloadFlutterVersion(),
              child: const Text("Download"),
            ),
          ],
        ),

        /// Select project path
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Target Flutter Project:'),
            8.width,
            Expanded(
              child: TextFormField(
                enabled: false,
                controller: _projectPathController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Selected Flutter Project Path',
                  border: InputBorder.none,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _selectPath();
              },
              child: Text('Select Project Path'),
            ),
          ],
        ),

        /// Switch using available local version
        Row(
          children: [
            const Text("Select new Flutter version to switch:"),
            8.width,
            DropdownButton<String>(
              value: _selectedVersion.isNotEmpty ? _selectedVersion : null,
              hint: const Text("Select Flutter Version"),
              items: _downloadedFlutterVersions
                  .map((version) => DropdownMenuItem(
                        value: version,
                        child: Text(version),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVersion = value!;
                });
              },
            ),
            8.width,
            IconButton(
                onPressed: () {
                  _fetchDownloadedFlutterVersions();
                },
                icon: Icon(FluentIcons.arrow_sync_16_regular)),
            Spacer(),
            8.width,
            ElevatedButton(
              onPressed: () =>
                  _switchFlutterVersion(_projectPathController.text),
              child: const Text("Switch"),
            ),
          ],
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceContainerLow),
            child: SingleChildScrollView(child: Text(_commandOutput, style: GoogleFonts.inconsolata(),)),
          ),
        ),
      ],
    );
  }
}
