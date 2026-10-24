// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReferralProgramImpl _$$ReferralProgramImplFromJson(
        Map<String, dynamic> json) =>
    _$ReferralProgramImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      rewardType: $enumDecode(_$ReferralRewardTypeEnumMap, json['rewardType']),
      referrerRewardValue: (json['referrerRewardValue'] as num).toInt(),
      refereeRewardValue: (json['refereeRewardValue'] as num).toInt(),
      referrerRewardDescription: json['referrerRewardDescription'] as String?,
      refereeRewardDescription: json['refereeRewardDescription'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      maxReferrals: (json['maxReferrals'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
      terms: json['terms'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ReferralProgramImplToJson(
        _$ReferralProgramImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'rewardType': _$ReferralRewardTypeEnumMap[instance.rewardType]!,
      'referrerRewardValue': instance.referrerRewardValue,
      'refereeRewardValue': instance.refereeRewardValue,
      'referrerRewardDescription': instance.referrerRewardDescription,
      'refereeRewardDescription': instance.refereeRewardDescription,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'maxReferrals': instance.maxReferrals,
      'isActive': instance.isActive,
      'terms': instance.terms,
    };

const _$ReferralRewardTypeEnumMap = {
  ReferralRewardType.points: 'points',
  ReferralRewardType.discount: 'discount',
  ReferralRewardType.freeItem: 'freeItem',
  ReferralRewardType.cashback: 'cashback',
  ReferralRewardType.tierUpgrade: 'tierUpgrade',
};

_$UserReferralImpl _$$UserReferralImplFromJson(Map<String, dynamic> json) =>
    _$UserReferralImpl(
      id: json['id'] as String,
      referrerId: json['referrerId'] as String,
      referrerName: json['referrerName'] as String,
      referrerAvatar: json['referrerAvatar'] as String?,
      refereeId: json['refereeId'] as String?,
      refereeName: json['refereeName'] as String?,
      refereeAvatar: json['refereeAvatar'] as String?,
      refereeEmail: json['refereeEmail'] as String?,
      refereePhone: json['refereePhone'] as String?,
      referralCode: json['referralCode'] as String,
      status: $enumDecode(_$ReferralStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      rewardedAt: json['rewardedAt'] == null
          ? null
          : DateTime.parse(json['rewardedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      referrerRewarded: json['referrerRewarded'] as bool? ?? false,
      refereeRewarded: json['refereeRewarded'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserReferralImplToJson(_$UserReferralImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referrerId': instance.referrerId,
      'referrerName': instance.referrerName,
      'referrerAvatar': instance.referrerAvatar,
      'refereeId': instance.refereeId,
      'refereeName': instance.refereeName,
      'refereeAvatar': instance.refereeAvatar,
      'refereeEmail': instance.refereeEmail,
      'refereePhone': instance.refereePhone,
      'referralCode': instance.referralCode,
      'status': _$ReferralStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'rewardedAt': instance.rewardedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'referrerRewarded': instance.referrerRewarded,
      'refereeRewarded': instance.refereeRewarded,
      'metadata': instance.metadata,
    };

const _$ReferralStatusEnumMap = {
  ReferralStatus.pending: 'pending',
  ReferralStatus.completed: 'completed',
  ReferralStatus.rewarded: 'rewarded',
  ReferralStatus.expired: 'expired',
};

_$ReferralStatsImpl _$$ReferralStatsImplFromJson(Map<String, dynamic> json) =>
    _$ReferralStatsImpl(
      totalReferrals: (json['totalReferrals'] as num).toInt(),
      completedReferrals: (json['completedReferrals'] as num).toInt(),
      pendingReferrals: (json['pendingReferrals'] as num).toInt(),
      totalRewardsEarned: (json['totalRewardsEarned'] as num).toInt(),
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
      cashbackEarned: (json['cashbackEarned'] as num?)?.toDouble() ?? 0.0,
      topReferredUsers: (json['topReferredUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lastReferralDate: json['lastReferralDate'] == null
          ? null
          : DateTime.parse(json['lastReferralDate'] as String),
      referralsByMonth:
          (json['referralsByMonth'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$$ReferralStatsImplToJson(_$ReferralStatsImpl instance) =>
    <String, dynamic>{
      'totalReferrals': instance.totalReferrals,
      'completedReferrals': instance.completedReferrals,
      'pendingReferrals': instance.pendingReferrals,
      'totalRewardsEarned': instance.totalRewardsEarned,
      'pointsEarned': instance.pointsEarned,
      'cashbackEarned': instance.cashbackEarned,
      'topReferredUsers': instance.topReferredUsers,
      'lastReferralDate': instance.lastReferralDate?.toIso8601String(),
      'referralsByMonth': instance.referralsByMonth,
    };

_$ReferralLeaderboardImpl _$$ReferralLeaderboardImplFromJson(
        Map<String, dynamic> json) =>
    _$ReferralLeaderboardImpl(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      totalReferrals: (json['totalReferrals'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReferralLeaderboardImplToJson(
        _$ReferralLeaderboardImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'totalReferrals': instance.totalReferrals,
      'rank': instance.rank,
      'pointsEarned': instance.pointsEarned,
    };
