import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/announcement_provider.dart';
import '../models/announcement_model.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  String _selectedFilter = 'Tout';
  final List<String> _filters = ['Tout', 'Sécurité', 'Travaux', 'Événements'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchAnnouncements();
    });
  }

  void _showAddAnnouncementDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    bool isUrgent = false;
    String selectedCategory = 'Sécurité';
    final List<String> categories = [
      'Sécurité',
      'Travaux',
      'Événements',
      'Information'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle annonce'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Titre
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre *',
                  hintText: 'Entrez le titre de l\'annonce',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Contenu
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Contenu *',
                  hintText: 'Décrivez l\'annonce en détail...',
                  prefixIcon: Icon(Icons.content_paste),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Catégorie
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
              const SizedBox(height: 16),

              // Urgent
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: AppColors.error),
                    const SizedBox(width: 12),
                    const Text(
                      'Marquer comme urgent',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    StatefulBuilder(
                      builder: (context, setState) => Switch(
                        value: isUrgent,
                        onChanged: (value) {
                          setState(() {
                            isUrgent = value;
                          });
                        },
                        activeColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez entrer un titre')),
                );
                return;
              }
              if (contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez entrer un contenu')),
                );
                return;
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Annonce "${titleController.text}" ajoutée avec succès'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('PUBLIER'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.currentUser?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Annonces'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        filter,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Liste des annonces
          Expanded(
            child: Consumer<AnnouncementProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.announcements.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune annonce',
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (isAdmin) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Appuyez sur le bouton + pour ajouter une annonce',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = provider.announcements[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/announcement-detail',
                            arguments: announcement,
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (announcement.isUrgent)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.error.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'URGENT',
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      announcement.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    announcement.formattedDate,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                announcement.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: AppColors.textHint,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Publié il y a ${DateTime.now().difference(announcement.publishedAt).inHours} heures',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.business_center,
                                    size: 12,
                                    color: AppColors.textHint,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      announcement.publishedBy.fullName,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textHint,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Bouton flottant pour ajouter une annonce (admin seulement)
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: _showAddAnnouncementDialog,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle annonce'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
