import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Aller aux paramètres
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Non connecté'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Photo de profil
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              user.initials,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nom
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.role.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Informations
                  Card(
                    child: Column(
                      children: [
                        _buildProfileItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email,
                        ),
                        const Divider(height: 1),
                        _buildProfileItem(
                          icon: Icons.phone_outlined,
                          label: 'Téléphone',
                          value: user.phoneNumber ?? 'Non renseigné',
                        ),
                        const Divider(height: 1),
                        _buildProfileItem(
                          icon: Icons.home_outlined,
                          label: 'Adresse',
                          value: user.adresse,
                        ),
                        const Divider(height: 1),
                        _buildProfileItem(
                          icon: Icons.badge_outlined,
                          label: 'Code utilisateur',
                          value: user.codeUtilisateur,
                        ),
                        const Divider(height: 1),
                        _buildProfileItem(
                          icon: Icons.credit_card_outlined,
                          label: 'CIN',
                          value: user.numCIN,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Boutons d'action
                  OutlinedButton.icon(
                    onPressed: () {
                      // Modifier le profil
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('MODIFIER LE PROFIL'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: () {
                      _showLogoutDialog(context, authProvider);
                    },
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: const Text('SE DÉCONNECTER'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          const SizedBox(width: 16),
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
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULER'),
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
