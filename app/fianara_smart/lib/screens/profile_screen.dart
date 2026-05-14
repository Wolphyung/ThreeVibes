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
      ),
      body: user == null
          ? const Center(child: Text('Non connecté'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Column(
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
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontSize: 22,
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
                            color: AppColors.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified,
                                size: 14,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Citoyen Vérifié • Fianarantsoa, MG',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${user.codeUtilisateur}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'INFORMATIONS PERSONNELLES',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Téléphone',
                          value: user.phoneNumber ?? '+261 34 22 333 44',
                        ),
                        const Divider(),
                        _buildInfoRow(
                          icon: Icons.credit_card_outlined,
                          label: 'Numéro CIN',
                          value: user.numCIN.isNotEmpty
                              ? user.numCIN
                              : 'Non renseigné',
                        ),
                        const Divider(),
                        _buildInfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Adresse',
                          value: user.adresse,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PARAMÈTRES DE L\'APPLICATION',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: Icon(Icons.notifications_none,
                              color: AppColors.primary),
                          title: const Text('Notifications'),
                          trailing: Switch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: AppColors.primary,
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.security, color: AppColors.primary),
                          title: const Text('Sécurité & MDP'),
                          trailing: const Icon(Icons.chevron_right),
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            _showSecurityDialog(context, authProvider);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.logout, color: AppColors.error),
                          title: const Text('Déconnexion'),
                          trailing: const Icon(Icons.chevron_right),
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            _showLogoutDialog(context, authProvider);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
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
                const SizedBox(height: 2),
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

  void _showSecurityDialog(BuildContext context, AuthProvider authProvider) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool _isCurrentPasswordVisible = false;
    bool _isNewPasswordVisible = false;
    bool _isConfirmPasswordVisible = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Sécurité & Mot de passe'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.security,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Changer votre mot de passe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pour votre sécurité, choisissez un mot de passe fort',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Mot de passe actuel
                  TextField(
                    controller: currentPasswordController,
                    obscureText: !_isCurrentPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe actuel',
                      hintText: 'Entrez votre mot de passe actuel',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isCurrentPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isCurrentPasswordVisible =
                                !_isCurrentPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nouveau mot de passe
                  TextField(
                    controller: newPasswordController,
                    obscureText: !_isNewPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Nouveau mot de passe',
                      hintText: 'Minimum 6 caractères',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNewPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirmation
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      hintText: 'Retapez votre nouveau mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Conseils de sécurité
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.warning),
                        const SizedBox(width: 12),
                        Expanded(
                          child: const Text(
                            'Utilisez au moins 8 caractères avec lettres, chiffres et symboles',
                            style: TextStyle(fontSize: 11),
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
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  _validateAndChangePassword(
                    context,
                    currentPasswordController.text,
                    newPasswordController.text,
                    confirmPasswordController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('MODIFIER'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _validateAndChangePassword(
    BuildContext context,
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) {
    // Validation du mot de passe actuel
    if (currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer votre mot de passe actuel'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validation du nouveau mot de passe
    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un nouveau mot de passe'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le mot de passe doit contenir au moins 6 caractères'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Vérification de la confirmation
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les mots de passe ne correspondent pas'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Simulation du changement (à remplacer par un vrai appel API)
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mot de passe modifié avec succès !'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 3),
      ),
    );

    // Optionnel : Déconnecter l'utilisateur pour le forcer à se reconnecter
    _showReconnectDialog(context);
  }

  void _showReconnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reconnexion nécessaire'),
        content: const Text(
          'Pour des raisons de sécurité, veuillez vous reconnecter avec votre nouveau mot de passe.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('SE RECONNECTER'),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
