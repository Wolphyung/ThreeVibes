import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/announcement_model.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'annonce'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (announcement.isUrgent)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'URGENT',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  announcement.formattedDate,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  announcement.publishedBy.fullName,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (announcement.imageUrl != null)
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(announcement.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Text(
              announcement.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.thumb_up_outlined,
                  label: '${announcement.likeCount} J\'aime',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Partager',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.bookmark_outline,
                  label: 'Enregistrer',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
