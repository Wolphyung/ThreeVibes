import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool _isEditing = false;

  final Map<String, String> _adminInfo = {
    'name': 'Admin Système',
    'email': 'admin@fianara.com',
    'role': 'Super Administrateur',
    'phone': '+261 34 12 345 67',
    'department': 'Sécurité Publique',
    'joined': 'Janvier 2024',
    'bio': 'Administrateur principal du système de signalement citoyen',
  };

  final Map<String, String> _editedInfo = {};

  @override
  void initState() {
    super.initState();
    _editedInfo.addAll(_adminInfo);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mon Profil Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Photo de profil
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statistiques admin
            Row(
              children: [
                _buildAdminStat(
                    'Actions', '156', Icons.touch_app, AppColors.primary),
                const SizedBox(width: 12),
                _buildAdminStat('Signalements', '245', Icons.report_problem,
                    AppColors.warning),
                const SizedBox(width: 12),
                _buildAdminStat('Jours actifs', '189', Icons.calendar_today,
                    AppColors.resolved),
              ],
            ),
            const SizedBox(height: 24),

            // Informations
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations personnelles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField(
                    label: 'Nom complet',
                    value: _adminInfo['name']!,
                    icon: Icons.person,
                    onChanged: (value) => _editedInfo['name'] = value,
                  ),
                  const Divider(),
                  _buildEditableField(
                    label: 'Email',
                    value: _adminInfo['email']!,
                    icon: Icons.email,
                    onChanged: (value) => _editedInfo['email'] = value,
                    enabled: false,
                  ),
                  const Divider(),
                  _buildEditableField(
                    label: 'Rôle',
                    value: _adminInfo['role']!,
                    icon: Icons.assignment_ind,
                    onChanged: (value) => _editedInfo['role'] = value,
                    enabled: false,
                  ),
                  const Divider(),
                  _buildEditableField(
                    label: 'Téléphone',
                    value: _adminInfo['phone']!,
                    icon: Icons.phone,
                    onChanged: (value) => _editedInfo['phone'] = value,
                  ),
                  const Divider(),
                  _buildEditableField(
                    label: 'Département',
                    value: _adminInfo['department']!,
                    icon: Icons.business,
                    onChanged: (value) => _editedInfo['department'] = value,
                  ),
                  const Divider(),
                  _buildEditableField(
                    label: 'Bio',
                    value: _adminInfo['bio']!,
                    icon: Icons.description,
                    onChanged: (value) => _editedInfo['bio'] = value,
                    maxLines: 3,
                  ),
                  const Divider(),
                  _buildEditableField(
                    label: 'Date d\'inscription',
                    value: _adminInfo['joined']!,
                    icon: Icons.calendar_today,
                    onChanged: (value) {},
                    enabled: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            if (!_isEditing) ...[
              ElevatedButton.icon(
                onPressed: () {
                  _showChangePasswordDialog();
                },
                icon: const Icon(Icons.lock_reset),
                label: const Text('CHANGER LE MOT DE PASSE'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppColors.warning,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  _showLogoutConfirmation(context, authProvider);
                },
                icon: const Icon(Icons.logout),
                label: const Text('SE DÉCONNECTER'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: AppColors.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStat(
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
            const SizedBox(height: 8),
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

  Widget _buildEditableField({
    required String label,
    required String value,
    required IconData icon,
    required Function(String) onChanged,
    bool enabled = true,
    int maxLines = 1,
  }) {
    if (_isEditing && enabled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      );
    }

    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    setState(() {
      _adminInfo.addAll(_editedInfo);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour avec succès')),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe actuel',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmer le mot de passe',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
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
                    content: Text('Mot de passe modifié avec succès')),
              );
            },
            child: const Text('MODIFIER'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(
      BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('DÉCONNECTER'),
          ),
        ],
      ),
    );
  }
}
