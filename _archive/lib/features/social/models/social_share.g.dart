// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_share.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShareContentImpl _$$ShareContentImplFromJson(Map<String, dynamic> json) =>
    _$ShareContentImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ShareContentTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      deepLink: json['deepLink'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ShareContentImplToJson(_$ShareContentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ShareContentTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'deepLink': instance.deepLink,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ShareContentTypeEnumMap = {
  ShareContentType.venue: 'venue',
  ShareContentType.event: 'event',
  ShareContentType.booking: 'booking',
  ShareContentType.review: 'review',
  ShareContentType.achievement: 'achievement',
  ShareContentType.invitation: 'invitation',
};

_$ShareAnalyticsImpl _$$ShareAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$ShareAnalyticsImpl(
      contentId: json['contentId'] as String,
      contentType: $enumDecode(_$ShareContentTypeEnumMap, json['contentType']),
      sharesByPlatform: (json['sharesByPlatform'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$SharePlatformEnumMap, k), (e as num).toInt()),
      ),
      totalShares: (json['totalShares'] as num).toInt(),
      clickThroughs: (json['clickThroughs'] as num).toInt(),
      conversions: (json['conversions'] as num).toInt(),
      firstSharedAt: DateTime.parse(json['firstSharedAt'] as String),
      lastSharedAt: json['lastSharedAt'] == null
          ? null
          : DateTime.parse(json['lastSharedAt'] as String),
    );

Map<String, dynamic> _$$ShareAnalyticsImplToJson(
        _$ShareAnalyticsImpl instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'contentType': _$ShareContentTypeEnumMap[instance.contentType]!,
      'sharesByPlatform': instance.sharesByPlatform
          .map((k, e) => MapEntry(_$SharePlatformEnumMap[k]!, e)),
      'totalShares': instance.totalShares,
      'clickThroughs': instance.clickThroughs,
      'conversions': instance.conversions,
      'firstSharedAt': instance.firstSharedAt.toIso8601String(),
      'lastSharedAt': instance.lastSharedAt?.toIso8601String(),
    };

const _$SharePlatformEnumMap = {
  SharePlatform.instagram: 'instagram',
  SharePlatform.facebook: 'facebook',
  SharePlatform.twitter: 'twitter',
  SharePlatform.whatsapp: 'whatsapp',
  SharePlatform.snapchat: 'snapchat',
  SharePlatform.messages: 'messages',
  SharePlatform.copy: 'copy',
  SharePlatform.more: 'more',
};

_$SocialPostImpl _$$SocialPostImplFromJson(Map<String, dynamic> json) =>
    _$SocialPostImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      content: ShareContent.fromJson(json['content'] as Map<String, dynamic>),
      caption: json['caption'] as String?,
      hashtags: (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      isLikedByUser: json['isLikedByUser'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SocialPostImplToJson(_$SocialPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'content': instance.content,
      'caption': instance.caption,
      'hashtags': instance.hashtags,
      'likes': instance.likes,
      'comments': instance.comments,
      'shares': instance.shares,
      'isLikedByUser': instance.isLikedByUser,
      'createdAt': instance.createdAt.toIso8601String(),
    };
