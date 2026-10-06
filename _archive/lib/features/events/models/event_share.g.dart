// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_share.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventShareImpl _$$EventShareImplFromJson(Map<String, dynamic> json) =>
    _$EventShareImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      shareToken: json['shareToken'] as String,
      shareUrl: json['shareUrl'] as String,
      sharedBy: json['sharedBy'] as String?,
      sharedByName: json['sharedByName'] as String?,
      platform: $enumDecodeNullable(_$SharePlatformEnumMap, json['platform']),
      clickCount: (json['clickCount'] as num?)?.toInt() ?? 0,
      signupCount: (json['signupCount'] as num?)?.toInt() ?? 0,
      referralCode: json['referralCode'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastClickedAt: json['lastClickedAt'] == null
          ? null
          : DateTime.parse(json['lastClickedAt'] as String),
    );

Map<String, dynamic> _$$EventShareImplToJson(_$EventShareImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'shareToken': instance.shareToken,
      'shareUrl': instance.shareUrl,
      'sharedBy': instance.sharedBy,
      'sharedByName': instance.sharedByName,
      'platform': _$SharePlatformEnumMap[instance.platform],
      'clickCount': instance.clickCount,
      'signupCount': instance.signupCount,
      'referralCode': instance.referralCode,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastClickedAt': instance.lastClickedAt?.toIso8601String(),
    };

const _$SharePlatformEnumMap = {
  SharePlatform.link: 'link',
  SharePlatform.facebook: 'facebook',
  SharePlatform.twitter: 'twitter',
  SharePlatform.instagram: 'instagram',
  SharePlatform.whatsapp: 'whatsapp',
  SharePlatform.sms: 'sms',
  SharePlatform.email: 'email',
  SharePlatform.qrCode: 'qr_code',
  SharePlatform.other: 'other',
};

_$ShareAnalyticsImpl _$$ShareAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$ShareAnalyticsImpl(
      eventId: json['eventId'] as String,
      totalShares: (json['totalShares'] as num).toInt(),
      totalClicks: (json['totalClicks'] as num).toInt(),
      totalSignups: (json['totalSignups'] as num).toInt(),
      sharesByPlatform: (json['sharesByPlatform'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$SharePlatformEnumMap, k), (e as num).toInt()),
      ),
      clicksByPlatform: (json['clicksByPlatform'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$SharePlatformEnumMap, k), (e as num).toInt()),
      ),
      topSharers: (json['topSharers'] as List<dynamic>)
          .map((e) => TopSharer.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$ShareAnalyticsImplToJson(
        _$ShareAnalyticsImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'totalShares': instance.totalShares,
      'totalClicks': instance.totalClicks,
      'totalSignups': instance.totalSignups,
      'sharesByPlatform': instance.sharesByPlatform
          .map((k, e) => MapEntry(_$SharePlatformEnumMap[k]!, e)),
      'clicksByPlatform': instance.clicksByPlatform
          .map((k, e) => MapEntry(_$SharePlatformEnumMap[k]!, e)),
      'topSharers': instance.topSharers,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_$TopSharerImpl _$$TopSharerImplFromJson(Map<String, dynamic> json) =>
    _$TopSharerImpl(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      shareCount: (json['shareCount'] as num).toInt(),
      clickCount: (json['clickCount'] as num).toInt(),
      signupCount: (json['signupCount'] as num).toInt(),
    );

Map<String, dynamic> _$$TopSharerImplToJson(_$TopSharerImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'shareCount': instance.shareCount,
      'clickCount': instance.clickCount,
      'signupCount': instance.signupCount,
    };

_$ShareContentImpl _$$ShareContentImplFromJson(Map<String, dynamic> json) =>
    _$ShareContentImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String?,
      hashtags: (json['hashtags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      via: json['via'] as String?,
    );

Map<String, dynamic> _$$ShareContentImplToJson(_$ShareContentImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'imageUrl': instance.imageUrl,
      'hashtags': instance.hashtags,
      'via': instance.via,
    };
