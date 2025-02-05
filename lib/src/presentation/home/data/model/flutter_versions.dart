import 'package:freezed_annotation/freezed_annotation.dart';

part 'flutter_versions.freezed.dart';
part 'flutter_versions.g.dart';

@freezed
class OnlineFlutterSDK with _$OnlineFlutterSDK {
  const factory OnlineFlutterSDK({
    required String hash,
    required String channel,
    required String version,
    required String sha256,
    required String? dartSdkArch,
    required String? dartSdkVersion,
    required String channelName,
    required String archiveUrl,
  }) = _OnlineFlutterSDK;

  factory OnlineFlutterSDK.fromJson(Map<String, dynamic> json) =>
      _$OnlineFlutterSDKFromJson(json);
}

@freezed
class OnlineFlutterSDKVersions with _$OnlineFlutterSDKVersions {
  const factory OnlineFlutterSDKVersions({
    required List<OnlineFlutterSDK> versions,
  }) = _OnlineFlutterSDKVersions;

  factory OnlineFlutterSDKVersions.fromJson(List<dynamic> json) =>
      _OnlineFlutterSDKVersions(
        versions: json.map((e) => OnlineFlutterSDK.fromJson(e)).toList(),
      );
}
