import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

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
    'Techniciens',
    'Administrateurs'
  ];

  // Liste des utilisateurs mock
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Jean Dupont',
      'email': 'jean.dupont@email.com',
      'role': 'Citoyen',
      'status': 'Actif',
      'reports': 12,
      'joined': '2024-01-15',
      'phone': '+261 34 12 345 67',
      'adresse': 'Ambatovolo, Fianarantsoa',
      'cin': '10123456789',
    },
    {
      'id': '2',
      'name': 'Marie Martin',
      'email': 'marie.martin@email.com',
      'role': 'Administrateur',
      'status': 'Actif',
      'reports': 45,
      'joined': '2023-11-20',
      'phone': '+261 34 23 456 78',
      'adresse': 'Centre ville, Fianarantsoa',
      'cin': '10123456790',
    },
    {
      'id': '3',
      'name': 'Ahmed Ben Ali',
      'email': 'ahmed.benali@email.com',
      'role': 'Technicien',
      'status': 'Inactif',
      'reports': 23,
      'joined': '2024-02-10',
      'phone': '+261 34 34 567 89',
      'adresse': 'Andrainjato, Fianarantsoa',
      'cin': '10123456791',
    },
    {
      'id': '4',
      'name': 'Sophie Lefebvre',
      'email': 'sophie.lefebvre@email.com',
      'role': 'Citoyen',
      'status': 'Actif',
      'reports': 8,
      'joined': '2024-03-05',
      'phone': '+261 34 45 678 90',
      'adresse': 'Manandona, Fianarantsoa',
      'cin': '10123456792',
    },
    {
      'id': '5',
      'name': 'Admin System',
      'email': 'admin@test.com',
      'role': 'Administrateur',
      'status': 'Actif',
      'reports': 156,
      'joined': '2023-01-01',
      'phone': '+261 34 00 000 00',
      'adresse': 'Mairie, Fianarantsoa',
      'cin': 'ADMIN001',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _selectedRole == 'Tous'
        ? _users
        : _users.where((user) {
            if (_selectedRole == 'Citoyens') return user['role'] == 'Citoyen';
            if (_selectedRole == 'Techniciens') {
              return user['role'] == 'Technicien';
            }
            if (_selectedRole == 'Administrateurs') {
              return user['role'] == 'Administrateur';
            }
            return true;
          }).toList();

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
                    'Actifs', '4', Icons.check_circle, AppColors.resolved),
                const SizedBox(width: 12),
                _buildUserStat(
                    'Nouveaux', '2', Icons.person_add, AppColors.warning),
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
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
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
        height: MediaQuery.of(context).size.height * 0.8,
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
                    _buildInfoRow('Rôle', user['role'],
                        statusColor: _getRoleColor(user['role'])),
                    _buildInfoRow('Statut', user['status']),
                    _buildInfoRow('Téléphone', user['phone']),
                    _buildInfoRow('Adresse', user['adresse']),
                    _buildInfoRow('CIN', user['cin']),
                    _buildInfoRow('Signalements', user['reports'].toString()),
                    _buildInfoRow('Date inscription', user['joined']),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showEditUserDialog(user);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('MODIFIER'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showDeleteConfirmation(user);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('SUPPRIMER'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (user['role'] != 'Administrateur') ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showChangeRoleDialog(user);
                          },
                          icon: const Icon(Icons.swap_horiz),
                          label: const Text('CHANGER LE RÔLE'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: statusColor != null
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontSize: 14),
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
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
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
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Adresse',
                    prefixIcon: Icon(Icons.home),
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
                        value: 'Technicien', child: Text('Technicien')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 12),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe temporaire',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Utilisateur ajouté avec succès')),
              );
            },
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
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
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
                TextField(
                  controller: TextEditingController(text: user['phone']),
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: TextEditingController(text: user['adresse']),
                  decoration: const InputDecoration(
                    labelText: 'Adresse',
                    prefixIcon: Icon(Icons.home),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Utilisateur modifié avec succès')),
              );
            },
            child: const Text('ENREGISTRER'),
          ),
        ],
      ),
    );
  }

  void _showChangeRoleDialog(Map<String, dynamic> user) {
    final newRole = user['role'] == 'Citoyen' ? 'Technicien' : 'Citoyen';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le rôle'),
        content: Text(
            'Voulez-vous changer le rôle de ${user['name']} de "${user['role']}" à "$newRole" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Rôle changé : ${user['name']} est maintenant $newRole')),
              );
            },
            child: const Text('CONFIRMER'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'utilisateur'),
        content: Text('Voulez-vous vraiment supprimer ${user['name']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Utilisateur ${user['name']} supprimé')),
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

  void _exportUsers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportation des utilisateurs en cours...')),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Administrateur':
        return AppColors.error;
      case 'Technicien':
        return AppColors.warning;
      case 'Citoyen':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}
