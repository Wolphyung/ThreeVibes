// lib/features/admin/presentation/screens/admin_users_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _selectedRole = 'Tous';
  final List<String> _roles = [
    'Tous',
    'Citoyens',
    'Administrateurs',
    'Modérateurs'
  ];

  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Jean Dupont',
      'email': 'jean.dupont@email.com',
      'role': 'Citoyen',
      'status': 'Actif',
      'reports': 12,
      'joined': '2024-01-15',
    },
    {
      'id': '2',
      'name': 'Marie Martin',
      'email': 'marie.martin@email.com',
      'role': 'Administrateur',
      'status': 'Actif',
      'reports': 45,
      'joined': '2023-11-20',
    },
    {
      'id': '3',
      'name': 'Ahmed Ben Ali',
      'email': 'ahmed.benali@email.com',
      'role': 'Modérateur',
      'status': 'Inactif',
      'reports': 23,
      'joined': '2024-02-10',
    },
    {
      'id': '4',
      'name': 'Sophie Lefebvre',
      'email': 'sophie.lefebvre@email.com',
      'role': 'Citoyen',
      'status': 'Actif',
      'reports': 8,
      'joined': '2024-03-05',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _selectedRole == 'Tous'
        ? _users
        : _users.where((user) => user['role'] == _selectedRole).toList();

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
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddUserDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _exportUsers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistiques
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildUserStat('Total', _users.length.toString(), Icons.people,
                    AppColors.primary),
                const SizedBox(width: 12),
                _buildUserStat(
                    'Actifs', '32', Icons.check_circle, AppColors.resolved),
                const SizedBox(width: 12),
                _buildUserStat(
                    'Nouveaux', '8', Icons.person_add, AppColors.warning),
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
                      selectedColor: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Liste des utilisateurs
          Expanded(
            child: ListView.builder(
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

  Widget _buildUserCard(Map<String, dynamic> user) {
    final isActive = user['status'] == 'Actif';
    final roleColor = _getRoleColor(user['role']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showUserDetails(user);
        },
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
                    user['name'][0],
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
                      user['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'],
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
                            user['role'],
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
                          user['status'],
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
                    '${user['reports']} signalements',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Inscrit le ${user['joined']}',
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

  void _showUserDetails(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user['name'][0],
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        user['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        user['email'],
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInfoRow('Rôle', user['role']),
                    _buildInfoRow('Statut', user['status']),
                    _buildInfoRow('Signalements', user['reports'].toString()),
                    _buildInfoRow('Date inscription', user['joined']),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.block),
                            label: const Text('DÉSACTIVER'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showEditUserDialog(user);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('MODIFIER'),
                          ),
                        ),
                      ],
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nom complet',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Rôle',
                prefixIcon: Icon(Icons.assignment_ind),
              ),
              items: const [
                DropdownMenuItem(value: 'Citoyen', child: Text('Citoyen')),
                DropdownMenuItem(
                    value: 'Modérateur', child: Text('Modérateur')),
                DropdownMenuItem(
                    value: 'Administrateur', child: Text('Administrateur')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('AJOUTER'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: user['name']),
              decoration: const InputDecoration(
                labelText: 'Nom complet',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: user['email']),
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: user['role'],
              decoration: const InputDecoration(
                labelText: 'Rôle',
                prefixIcon: Icon(Icons.assignment_ind),
              ),
              items: const [
                DropdownMenuItem(value: 'Citoyen', child: Text('Citoyen')),
                DropdownMenuItem(
                    value: 'Modérateur', child: Text('Modérateur')),
                DropdownMenuItem(
                    value: 'Administrateur', child: Text('Administrateur')),
              ],
              onChanged: (value) {},
            ),
          ],
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

  void _exportUsers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportation en cours...')),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Administrateur':
        return AppColors.error;
      case 'Modérateur':
        return AppColors.warning;
      case 'Citoyen':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}
