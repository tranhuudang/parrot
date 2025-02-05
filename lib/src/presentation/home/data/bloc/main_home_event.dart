part of 'main_home_bloc.dart';

abstract class MainHomeEvent {}

class InitializeHome extends MainHomeEvent {}

class CheckFvmInstallation extends MainHomeEvent {}

class FetchOnlineFlutterVersions extends MainHomeEvent {}

class DownloadFlutterVersion extends MainHomeEvent {}

class FetchDownloadedFlutterVersions extends MainHomeEvent {}

class SwitchFlutterVersion extends MainHomeEvent {
  final String projectPath;

  SwitchFlutterVersion(this.projectPath);
}

class InstallFvm extends MainHomeEvent {}

class SelectProjectPath extends MainHomeEvent {}

class SelectOnlineVersion extends MainHomeEvent {
  final String version;

  SelectOnlineVersion(this.version);
}

class SelectDownloadedVersion extends MainHomeEvent {
  final String version;

  SelectDownloadedVersion(this.version);
}
