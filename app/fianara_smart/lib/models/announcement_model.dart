import 'user_model.dart';

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final List<String> mediaUrls;
  final UserModel publishedBy;
  final DateTime publishedAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;
  final bool isUrgent;
  final bool isPublic;
  final List<String> targetRoles;
  final int viewCount;
  final int likeCount;
  final List<String> likedBy;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.mediaUrls = const [],
    required this.publishedBy,
    required this.publishedAt,
    this.updatedAt,
    this.expiresAt,
    this.isUrgent = false,
    this.isPublic = true,
    this.targetRoles = const [],
    this.viewCount = 0,
    this.likeCount = 0,
    this.likedBy = const [],
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      publishedBy: UserModel.fromJson(json['publishedBy'] ?? {}),
      publishedAt:
          DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
      isUrgent: json['isUrgent'] ?? false,
      isPublic: json['isPublic'] ?? true,
      targetRoles: List<String>.from(json['targetRoles'] ?? []),
      viewCount: json['viewCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'mediaUrls': mediaUrls,
      'publishedBy': publishedBy.toJson(),
      'publishedAt': publishedAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isUrgent': isUrgent,
      'isPublic': isPublic,
      'targetRoles': targetRoles,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'likedBy': likedBy,
    };
  }

  String get formattedDate {
    return '${publishedAt.day}/${publishedAt.month}/${publishedAt.year}';
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isNew {
    return DateTime.now().difference(publishedAt).inDays < 3;
  }
}
