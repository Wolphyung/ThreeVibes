// lib/features/admin/presentation/screens/admin_users_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';
import '../providers/admin_users_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _selectedRole = 'Tous';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _roles = [
    'Tous',
    'Citoyens',
    'Techniciens',
    'Administrateurs'
  ];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token != null) {
      await Provider.of<AdminUsersProvider>(context, listen: false)
          .fetchUsers(token);
    }
  }

  List<UserModel> get _filteredUsers {
    final provider = Provider.of<AdminUsersProvider>(context, listen: false);
    var filtered = provider.users;

    // Filtre par rôle
    if (_selectedRole != 'Tous') {
      filtered = filtered.where((user) {
        if (_selectedRole == 'Citoyens') return user.role == UserRole.citizen;
        if (_selectedRole == 'Techniciens')
          return user.role == UserRole.technician;
        if (_selectedRole == 'Administrateurs')
          return user.role == UserRole.admin;
        return true;
      }).toList();
    }

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        final nom = user.nom.toLowerCase();
        final prenoms = user.prenoms.toLowerCase();
        final cin = user.numCIN.toLowerCase();
        final query = _searchQuery.toLowerCase();

        return nom.contains(query) ||
            prenoms.contains(query) ||
            cin.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminUsersProvider>(context);
    final filteredUsers = _filteredUsers;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Gestion des Utilisateurs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadUsers(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchBar(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddUserDialog(),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(provider.errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUsers,
                        child: const Text('RÉESSAYER'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (_searchQuery.isNotEmpty ||
                        _searchController.text.isNotEmpty)
                      _buildSearchBar(),

                    // Statistiques
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildUserStat(
                              'Total',
                              provider.totalUsers.toString(),
                              Icons.people,
                              AppColors.primary),
                          const SizedBox(width: 12),
                          _buildUserStat(
                              'Actifs',
                              provider.activeUsers.toString(),
                              Icons.check_circle,
                              AppColors.resolved),
                          const SizedBox(width: 12),
                          _buildUserStat(
                              'Nouveaux',
                              provider.newUsers.toString(),
                              Icons.person_add,
                              AppColors.warning),
                        ],
                      ),
                    ),

                    // Filtres
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: List.generate(_roles.length, (index) {
                            final role = _roles[index];
                            final isSelected = _selectedRole == role;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: FilterChip(
                                label: Text(role),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedRole = role;
                                  });
                                },
                                backgroundColor: Colors.grey[100],
                                selectedColor:
                                    AppColors.primary.withValues(alpha: 0.1),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Résultat de recherche
                    if (_searchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${filteredUsers.length} résultat(s) trouvé(s)',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                              },
                              child: const Text('Effacer'),
                            ),
                          ],
                        ),
                      ),

                    // Liste des utilisateurs
                    Expanded(
                      child: filteredUsers.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Aucun utilisateur trouvé',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];
                                return _buildUserCard(user);
                              },
                            ),
                    ),
                  ],
                ),
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
                hintText: 'Rechercher par nom, prénom ou CIN...',
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

  Widget _buildUserStat(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    final isActive = user.isActive;
    final roleColor = _getRoleColor(user.role);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showUserDetails(user),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user.fullName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.roleString,
                            style: TextStyle(
                              fontSize: 10,
                              color: roleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.resolved : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isActive ? 'Actif' : 'Inactif',
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive ? AppColors.resolved : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'CIN: ${user.numCIN}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.createdAt.toString().split(' ')[0],
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserDetails(UserModel user) {
    // Afficher les détails de l'utilisateur
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(user.fullName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Email: ${user.email}'),
            Text('CIN: ${user.numCIN}'),
            Text('Adresse: ${user.adresse}'),
            Text('Rôle: ${user.roleString}'),
            Text('Date inscription: ${user.createdAt}'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showEditUserDialog(user),
                    child: const Text('MODIFIER'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showDeleteConfirmation(user),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('SUPPRIMER'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserDialog(UserModel user) {
    // Implémenter l'édition
  }

  void _showAddUserDialog() {
    // Implémenter l'ajout
  }

  void _showDeleteConfirmation(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Voulez-vous vraiment supprimer ${user.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              final provider =
                  Provider.of<AdminUsersProvider>(context, listen: false);
              await provider.deleteUser(user.id, authProvider.token!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Utilisateur supprimé')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('SUPPRIMER'),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppColors.error;
      case UserRole.technician:
        return AppColors.warning;
      case UserRole.citizen:
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}
