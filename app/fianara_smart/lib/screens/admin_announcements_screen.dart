// lib/features/admin/presentation/screens/admin_announcements_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class AdminAnnouncementsScreen extends StatefulWidget {
  const AdminAnnouncementsScreen({super.key});

  @override
  State<AdminAnnouncementsScreen> createState() =>
      _AdminAnnouncementsScreenState();
}

class _AdminAnnouncementsScreenState extends State<AdminAnnouncementsScreen> {
  final List<Map<String, dynamic>> _announcements = [
    {
      'id': '1',
      'title': 'Coupure d\'eau programmée',
      'content':
          'Une coupure d\'eau aura lieu demain de 9h à 14h dans tout le quartier.',
      'date': '2024-12-20',
      'priority': 'Élevée',
      'status': 'Publiée',
      'views': 234,
    },
    {
      'id': '2',
      'title': 'Réunion citoyenne',
      'content':
          'Réunion sur la sécurité du quartier ce vendredi à 18h à la mairie.',
      'date': '2024-12-18',
      'priority': 'Normale',
      'status': 'Publiée',
      'views': 89,
    },
    {
      'id': '3',
      'title': 'Alerte météo',
      'content': 'Fortes pluies attendues demain, soyez vigilants.',
      'date': '2024-12-22',
      'priority': 'Élevée',
      'status': 'Brouillon',
      'views': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Gestion des Annonces',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddAnnouncementDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          return _buildAnnouncementCard(announcement);
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    final priorityColor = announcement['priority'] == 'Élevée'
        ? AppColors.error
        : AppColors.warning;
    final isPublished = announcement['status'] == 'Publiée';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.campaign,
                    color: priorityColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        announcement['date'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    announcement['priority'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              announcement['content'],
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${announcement['views']} vues',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (!isPublished)
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.publish, size: 16),
                        label: const Text('Publier'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.resolved,
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () {
                        _showEditAnnouncementDialog(announcement);
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Modifier'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _showDeleteConfirmation();
                      },
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Supprimer'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAnnouncementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle annonce'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Contenu',
                  prefixIcon: Icon(Icons.content_paste),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Priorité',
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: const [
                  DropdownMenuItem(value: 'Normale', child: Text('Normale')),
                  DropdownMenuItem(value: 'Élevée', child: Text('Élevée')),
                  DropdownMenuItem(value: 'Urgente', child: Text('Urgente')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('PUBLIER'),
          ),
        ],
      ),
    );
  }

  void _showEditAnnouncementDialog(Map<String, dynamic> announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier l\'annonce'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: announcement['title']),
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller:
                    TextEditingController(text: announcement['content']),
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Contenu',
                  prefixIcon: Icon(Icons.content_paste),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: announcement['priority'],
                decoration: const InputDecoration(
                  labelText: 'Priorité',
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: const [
                  DropdownMenuItem(value: 'Normale', child: Text('Normale')),
                  DropdownMenuItem(value: 'Élevée', child: Text('Élevée')),
                  DropdownMenuItem(value: 'Urgente', child: Text('Urgente')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ENREGISTRER'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous vraiment supprimer cette annonce ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('SUPPRIMER'),
          ),
        ],
      ),
    );
  }
}
