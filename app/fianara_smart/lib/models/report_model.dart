import 'package:flutter/material.dart';
import 'user_model.dart';

enum ReportType {
  cleanliness('Propreté', Icons.cleaning_services),
  infrastructure('Infrastructure', Icons.build),
  security('Sécurité', Icons.security),
  traffic('Trafic', Icons.traffic),
  lighting('Éclairage', Icons.lightbulb),
  waste('Déchets', Icons.delete),
  water('Eau', Icons.water_damage),
  other('Autre', Icons.report_problem);

  final String label;
  final IconData icon;
  const ReportType(this.label, this.icon);

  static ReportType fromString(String type) {
    return ReportType.values.firstWhere(
      (e) => e.label == type,
      orElse: () => ReportType.other,
    );
  }
}

enum ReportStatus {
  pending('En attente', Color(0xFFF59E0B)),
  inProgress('En cours', Color(0xFF3B82F6)),
  resolved('Résolu', Color(0xFF10B981)),
  rejected('Rejeté', Color(0xFFEF4444));

  final String label;
  final Color color;
  const ReportStatus(this.label, this.color);

  static ReportStatus fromString(String status) {
    return ReportStatus.values.firstWhere(
      (e) => e.label == status,
      orElse: () => ReportStatus.pending,
    );
  }
}

class ReportModel {
  final String id;
  final String title;
  final String description;
  final ReportType type;
  final ReportStatus status;
  final double latitude;
  final double longitude;
  final String locationAddress;
  final String? imageUrl;
  final List<String> mediaUrls;
  final UserModel reportedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final String? resolvedNotes;
  final UserModel? assignedTo;
  final int upvotes;
  final int downvotes;
  final List<String> upvotedBy;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.locationAddress,
    this.imageUrl,
    this.mediaUrls = const [],
    required this.reportedBy,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.resolvedNotes,
    this.assignedTo,
    this.upvotes = 0,
    this.downvotes = 0,
    this.upvotedBy = const [],
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: ReportType.fromString(json['type'] ?? 'Autre'),
      status: ReportStatus.fromString(json['status'] ?? 'En attente'),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      locationAddress: json['locationAddress'] ?? '',
      imageUrl: json['imageUrl'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      reportedBy: UserModel.fromJson(json['reportedBy'] ?? {}),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.tryParse(json['resolvedAt'])
          : null,
      resolvedNotes: json['resolvedNotes'],
      assignedTo: json['assignedTo'] != null
          ? UserModel.fromJson(json['assignedTo'])
          : null,
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
      upvotedBy: List<String>.from(json['upvotedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.label,
      'status': status.label,
      'latitude': latitude,
      'longitude': longitude,
      'locationAddress': locationAddress,
      'imageUrl': imageUrl,
      'mediaUrls': mediaUrls,
      'reportedBy': reportedBy.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolvedNotes': resolvedNotes,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'upvotedBy': upvotedBy,
    };
  }

  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year} à ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 7) return formattedDate;
    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    }
    if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    }
    if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    }
    return 'À l\'instant';
  }
}
