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
  String _searchQuery = '';
  String _selectedFilter = 'Toutes';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['Toutes', 'En attente', 'Validée', 'Rejetée'];

  // Annonces créées par l'admin
  List<Map<String, dynamic>> _announcements = [
    {
      'id': '1',
      'title': 'Coupure d\'eau programmée',
      'content':
          'Une coupure d\'eau aura lieu demain de 9h à 14h dans tout le quartier.',
      'date': '2024-12-20',
      'priority': 'Élevée',
      'status': 'Validée',
      'isValidated': true,
      'source': 'admin',
      'rejectionReason': null,
      'createdBy': 'Admin',
    },
    {
      'id': '2',
      'title': 'Réunion citoyenne',
      'content':
          'Réunion sur la sécurité du quartier ce vendredi à 18h à la mairie.',
      'date': '2024-12-18',
      'priority': 'Normale',
      'status': 'Validée',
      'isValidated': true,
      'source': 'admin',
      'rejectionReason': null,
      'createdBy': 'Admin',
    },
  ];

  // Annonces des utilisateurs en attente de validation
  List<Map<String, dynamic>> _userAnnouncements = [
    {
      'id': 'u1',
      'title': 'Incendie dans le quartier',
      'content':
          'Un départ de feu a été signalé rue de la Liberté. Les pompiers sont en route.',
      'date': '2024-12-21',
      'priority': 'Urgente',
      'status': 'En attente',
      'isValidated': false,
      'source': 'user',
      'createdBy': 'Jean Dupont',
      'userEmail': 'jean.dupont@email.com',
      'userPhone': '+216 12 345 678',
      'rejectionReason': null,
    },
    {
      'id': 'u2',
      'title': 'Fuite d\'eau',
      'content': 'Fuite d\'eau importante avenue Bourguiba.',
      'date': '2024-12-20',
      'priority': 'Élevée',
      'status': 'En attente',
      'isValidated': false,
      'source': 'user',
      'createdBy': 'Marie Martin',
      'userEmail': 'marie.martin@email.com',
      'userPhone': '+216 98 765 432',
      'rejectionReason': null,
    },
    {
      'id': 'u3',
      'title': 'Déchet sauvage',
      'content': 'Dépôt illégal d\'ordures derrière l\'école primaire.',
      'date': '2024-12-19',
      'priority': 'Normale',
      'status': 'En attente',
      'isValidated': false,
      'source': 'user',
      'createdBy': 'Ahmed Ben Ali',
      'userEmail': 'ahmed.benali@email.com',
      'userPhone': '+216 55 555 555',
      'rejectionReason': null,
    },
  ];

  List<Map<String, dynamic>> get _allAnnouncements {
    return [..._announcements, ..._userAnnouncements];
  }

  List<Map<String, dynamic>> get _filteredAnnouncements {
    var filtered = _allAnnouncements;

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((a) =>
              a['title']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              a['content']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              a['createdBy']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filtre par statut
    if (_selectedFilter != 'Toutes') {
      filtered = filtered.where((a) => a['status'] == _selectedFilter).toList();
    }

    return filtered;
  }

  int get pendingCount =>
      _userAnnouncements.where((a) => a['status'] == 'En attente').length;
  int get validatedCount =>
      _announcements.where((a) => a['status'] == 'Validée').length +
      _userAnnouncements.where((a) => a['status'] == 'Validée').length;
  int get rejectedCount =>
      _userAnnouncements.where((a) => a['status'] == 'Rejetée').length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchBar();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddAnnouncementDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          if (_searchQuery.isNotEmpty || _searchController.text.isNotEmpty)
            _buildSearchBar(),

          // Filtres
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Statistiques
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'En attente',
                  pendingCount.toString(),
                  Icons.pending,
                  AppColors.warning,
                ),
                _buildStatItem(
                  'Validées',
                  validatedCount.toString(),
                  Icons.check_circle,
                  AppColors.resolved,
                ),
                _buildStatItem(
                  'Rejetées',
                  rejectedCount.toString(),
                  Icons.cancel,
                  AppColors.error,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Liste des annonces
          Expanded(
            child: _filteredAnnouncements.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune annonce',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredAnnouncements.length,
                    itemBuilder: (context, index) {
                      final announcement = _filteredAnnouncements[index];
                      return _buildAnnouncementCard(announcement);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Rechercher une annonce...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showSearchBar() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus();
    });
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    final priorityColor = announcement['priority'] == 'Élevée' ||
            announcement['priority'] == 'Urgente'
        ? AppColors.error
        : AppColors.warning;
    final isValidated = announcement['isValidated'] == true;
    final statusColor = isValidated
        ? AppColors.resolved
        : (announcement['status'] == 'Rejetée'
            ? AppColors.error
            : AppColors.warning);
    final isFromUser = announcement['source'] == 'user';

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
                    isFromUser ? Icons.person : Icons.admin_panel_settings,
                    color: priorityColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            announcement['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isFromUser)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Utilisateur',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${announcement['date']} • Par ${announcement['createdBy']}',
                        style: TextStyle(
                          fontSize: 11,
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
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    announcement['status'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
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

            // Informations supplémentaires pour les annonces utilisateur
            if (isFromUser && announcement['status'] == 'En attente')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.email, size: 12, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            announcement['userEmail'],
                            style: TextStyle(
                                fontSize: 11, color: AppColors.warning),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 12, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            announcement['userPhone'],
                            style: TextStyle(
                                fontSize: 11, color: AppColors.warning),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.priority_high,
                        size: 12,
                        color: priorityColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        announcement['priority'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: priorityColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Bouton Valider (visible seulement pour les annonces en attente)
                    if (!isValidated && announcement['status'] != 'Rejetée')
                      ElevatedButton.icon(
                        onPressed: () {
                          _validateAnnouncement(announcement);
                        },
                        icon: const Icon(Icons.check_circle, size: 16),
                        label: const Text('Valider'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.resolved,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                    if (!isValidated && announcement['status'] != 'Rejetée')
                      const SizedBox(width: 8),

                    // Bouton Rejeter (visible seulement pour les annonces en attente)
                    if (!isValidated && announcement['status'] != 'Rejetée')
                      OutlinedButton.icon(
                        onPressed: () {
                          _showRejectDialog(announcement);
                        },
                        icon: const Icon(Icons.cancel, size: 16),
                        label: const Text('Rejeter'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                    // Badge Validée
                    if (isValidated)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.resolved.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppColors.resolved,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Validée',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.resolved,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(width: 8),

                    // Bouton Modifier
                    TextButton.icon(
                      onPressed: () {
                        _showEditAnnouncementDialog(announcement);
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Modifier'),
                    ),

                    // Bouton Supprimer
                    TextButton.icon(
                      onPressed: () {
                        _showDeleteConfirmation(announcement);
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

            // Motif de rejet
            if (announcement['rejectionReason'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, size: 14, color: AppColors.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Motif du rejet: ${announcement['rejectionReason']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _validateAnnouncement(Map<String, dynamic> announcement) {
    setState(() {
      announcement['isValidated'] = true;
      announcement['status'] = 'Validée';

      // Si c'est une annonce utilisateur, on la déplace dans la liste des annonces validées
      if (announcement['source'] == 'user') {
        // Créer une copie pour la liste des annonces admin
        final validatedAnnouncement = Map<String, dynamic>.from(announcement);
        validatedAnnouncement['source'] = 'admin';
        validatedAnnouncement['createdBy'] = 'Admin (Validé)';
        _announcements.insert(0, validatedAnnouncement);

        // Supprimer de la liste des annonces utilisateur
        _userAnnouncements.removeWhere((a) => a['id'] == announcement['id']);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('L\'annonce "${announcement['title']}" a été validée'),
        backgroundColor: AppColors.resolved,
      ),
    );
  }

  void _showRejectDialog(Map<String, dynamic> announcement) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeter l\'annonce'),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Motif du rejet...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez entrer un motif')),
                );
                return;
              }

              setState(() {
                announcement['isValidated'] = false;
                announcement['status'] = 'Rejetée';
                announcement['rejectionReason'] = reasonController.text;
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'L\'annonce "${announcement['title']}" a été rejetée'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('REJETER'),
          ),
        ],
      ),
    );
  }

  void _showAddAnnouncementDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedPriority = 'Normale';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Nouvelle annonce (Admin)'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Contenu',
                      prefixIcon: Icon(Icons.content_paste),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priorité',
                      prefixIcon: Icon(Icons.priority_high),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Normale', child: Text('Normale')),
                      DropdownMenuItem(value: 'Élevée', child: Text('Élevée')),
                      DropdownMenuItem(
                          value: 'Urgente', child: Text('Urgente')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedPriority = value!;
                      });
                    },
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
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      contentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Veuillez remplir tous les champs')),
                    );
                    return;
                  }

                  final newAnnouncement = {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'title': titleController.text,
                    'content': contentController.text,
                    'date': DateTime.now().toString().split(' ')[0],
                    'priority': selectedPriority,
                    'status': 'Validée',
                    'isValidated': true,
                    'source': 'admin',
                    'createdBy': 'Admin',
                    'rejectionReason': null,
                  };

                  setState(() {
                    _announcements.insert(0, newAnnouncement);
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Annonce créée et validée'),
                      backgroundColor: AppColors.resolved,
                    ),
                  );
                },
                child: const Text('CRÉER'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditAnnouncementDialog(Map<String, dynamic> announcement) {
    final titleController = TextEditingController(text: announcement['title']);
    final contentController =
        TextEditingController(text: announcement['content']);
    String selectedPriority = announcement['priority'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Modifier l\'annonce'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Contenu',
                      prefixIcon: Icon(Icons.content_paste),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priorité',
                      prefixIcon: Icon(Icons.priority_high),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Normale', child: Text('Normale')),
                      DropdownMenuItem(value: 'Élevée', child: Text('Élevée')),
                      DropdownMenuItem(
                          value: 'Urgente', child: Text('Urgente')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedPriority = value!;
                      });
                    },
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
                onPressed: () {
                  setState(() {
                    announcement['title'] = titleController.text;
                    announcement['content'] = contentController.text;
                    announcement['priority'] = selectedPriority;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Annonce modifiée')),
                  );
                },
                child: const Text('ENREGISTRER'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content:
            Text('Voulez-vous vraiment supprimer "${announcement['title']}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Supprimer de la liste appropriée
                if (announcement['source'] == 'user') {
                  _userAnnouncements
                      .removeWhere((a) => a['id'] == announcement['id']);
                } else {
                  _announcements
                      .removeWhere((a) => a['id'] == announcement['id']);
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Annonce supprimée')),
              );
            },
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
