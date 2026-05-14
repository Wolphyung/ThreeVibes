// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cinController = TextEditingController();
  final _lieuCINController = TextEditingController();
  final _dateCINController = TextEditingController();
  final _adresseController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomsController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cinController.dispose();
    _lieuCINController.dispose();
    _dateCINController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        // Format YYYY-MM-DD pour l'API
        _dateCINController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Données au format exact attendu par l'API
    final userData = {
      "email": _emailController.text.trim(),
      "mdp": _passwordController.text,
      "nom": _nomController.text.trim(),
      "prenoms": _prenomsController.text.trim(),
      "numCIN": _cinController.text.trim(),
      "dateCIN": _dateCINController.text,
      "lieuCIN": _lieuCINController.text.trim(),
      "adresse": _adresseController.text.trim(),
      "role": "CITOYEN"
    };

    // Afficher les données pour debug
    print('Données envoyées: $userData');

    final success = await authProvider.register(userData);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inscription réussie! Veuillez vous connecter'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                authProvider.errorMessage ?? 'Erreur lors de l\'inscription'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Nom
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        labelText: 'Nom *',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Prénoms
                    TextFormField(
                      controller: _prenomsController,
                      decoration: const InputDecoration(
                        labelText: 'Prénoms *',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email *',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Champ requis';
                        if (!value!.contains('@') || !value.contains('.')) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // CIN
                    TextFormField(
                      controller: _cinController,
                      decoration: const InputDecoration(
                        labelText: 'Numéro CIN *',
                        prefixIcon: Icon(Icons.card_membership),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Date CIN
                    TextFormField(
                      controller: _dateCINController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: const InputDecoration(
                        labelText: 'Date CIN *',
                        prefixIcon: Icon(Icons.calendar_today),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Lieu CIN
                    TextFormField(
                      controller: _lieuCINController,
                      decoration: const InputDecoration(
                        labelText: 'Lieu de délivrance CIN *',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Adresse
                    TextFormField(
                      controller: _adresseController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Adresse *',
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Mot de passe
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe *',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Champ requis';
                        if (value!.length < 6) return 'Au moins 6 caractères';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirmer mot de passe
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe *',
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
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Champ requis';
                        if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Bouton d'inscription
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'S\'INSCRIRE',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lien vers connexion
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Déjà un compte?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text('Se connecter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
