import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_version_manager/src/core/core.dart';
import 'package:flutter_version_manager/src/presentation/home/data/model/downloaded_flutter_sdks.dart';

import '../../data/model/flutter_versions.dart';

class MainHomeBody extends StatefulWidget {
  const MainHomeBody({super.key});

  @override
  State<MainHomeBody> createState() => _MainHomeBodyState();
}

class _MainHomeBodyState extends State<MainHomeBody> {
  String _selectedVersion = '';
  List<String> _downloadedFlutterVersions = [];
  String _commandOutput = "Command output will appear here...";
  List<String> _availableVersions = [];
  String _fvmVersion = '';

  @override
  void initState() {
    super.initState();
    _checkFvmInstallation();
    _fetchOnlineFlutterVersions();
    //_fetchDownloadedFlutterVersions();
  }

  Future<void> _checkFvmInstallation() async {
    try {
      ProcessResult result = await Process.run('fvm', ['--version'],);
      setState(() {
        _fvmVersion = result.stdout.toString().trim();

      });
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

          //_selectedVersion = versions.isNotEmpty ? versions.first : '';
        });

        print('here');
        print(_availableVersions);
      } else {
        setState(() {
          _commandOutput += "Error fetching Flutter versions --: ${result.stderr}" + "\n";
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
  Future<void> _installFlutterVersion(String projectPath) async {
    if (_selectedVersion.isEmpty) return;

    setState(() {
      _commandOutput = "Installing Flutter $_selectedVersion...";
    });

    try {
      Process process = await Process.start(
          'fvm', ['install', _selectedVersion],
          workingDirectory: projectPath);

      process.stdout.transform(utf8.decoder).listen((data) {
        setState(() {
          _commandOutput = data;
        });
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        setState(() {
          _commandOutput = "Error: $data";
        });
      });

      await process.exitCode;
      setState(() {
        _commandOutput = "Flutter $_selectedVersion installed successfully!";
      });
    } catch (e) {
      setState(() {
        _commandOutput = "Error: $e";
      });
    }
  }

  Future<void> _fetchDownloadedFlutterVersions(String projectPath) async {
    try {
      ProcessResult result = await Process.run('fvm', ['api', 'list'], workingDirectory: projectPath);
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
      Process process = await Process.start('fvm', ['use', _selectedVersion],
          workingDirectory: projectPath);

      process.stdout.transform(utf8.decoder).listen((data) {
        setState(() {
          _commandOutput = data;
        });
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        setState(() {
          _commandOutput = "Error: $data";
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
        _fvmVersion.isEmpty
            ? FilledButton(
            onPressed: () => installFvm(_projectPathController.text),
            child: Text('Install FVM CLI'))
            : FilledButton(
            onPressed: () {}, child: Text('FVM Version: $_fvmVersion')),

        /// Select project
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _projectPathController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Selected Path',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (){
                _selectPath();
                },
              child: Text('Select Path'),
            ),
          ],
        ),


        /// Download online SDKs
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: _selectedVersion.isNotEmpty ? _selectedVersion : null,
                hint: const Text("Select Flutter Version"),
                items: _availableVersions
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
            ),
            ElevatedButton(
              onPressed: () =>
                  _installFlutterVersion(_projectPathController.text),
              child: const Text("Download"),
            ),
          ],
        ),

        /// Switch using available local version
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Select Flutter Version:"),
              8.width,
              Expanded(
                child: DropdownButton<String>(
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
              ),
              ElevatedButton(
                onPressed: () =>
                    _switchFlutterVersion(_projectPathController.text),
                child: const Text("Switch"),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_commandOutput),
            ),
          ),
        ),
      ],
    );
  }
}
