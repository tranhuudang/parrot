// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_versions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnlineFlutterSDKImpl _$$OnlineFlutterSDKImplFromJson(
        Map<String, dynamic> json) =>
    _$OnlineFlutterSDKImpl(
      hash: json['hash'] as String,
      channel: json['channel'] as String,
      version: json['version'] as String,
      sha256: json['sha256'] as String,
      dartSdkArch: json['dartSdkArch'] as String?,
      dartSdkVersion: json['dartSdkVersion'] as String?,
      channelName: json['channelName'] as String,
      archiveUrl: json['archiveUrl'] as String,
    );

Map<String, dynamic> _$$OnlineFlutterSDKImplToJson(
        _$OnlineFlutterSDKImpl instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'channel': instance.channel,
      'version': instance.version,
      'sha256': instance.sha256,
      'dartSdkArch': instance.dartSdkArch,
      'dartSdkVersion': instance.dartSdkVersion,
      'channelName': instance.channelName,
      'archiveUrl': instance.archiveUrl,
    };

_$OnlineFlutterSDKVersionsImpl _$$OnlineFlutterSDKVersionsImplFromJson(
        Map<String, dynamic> json) =>
    _$OnlineFlutterSDKVersionsImpl(
      versions: (json['versions'] as List<dynamic>)
          .map((e) => OnlineFlutterSDK.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OnlineFlutterSDKVersionsImplToJson(
        _$OnlineFlutterSDKVersionsImpl instance) =>
    <String, dynamic>{
      'versions': instance.versions,
    };
