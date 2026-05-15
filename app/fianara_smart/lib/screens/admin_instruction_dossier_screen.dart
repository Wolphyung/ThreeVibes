// lib/screens/admin_instruction_dossier_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/instruction_dossier_model.dart';
import '../providers/instruction_dossier_provider.dart';

class AdminInstructionDossierScreen extends StatefulWidget {
  const AdminInstructionDossierScreen({super.key});

  @override
  State<AdminInstructionDossierScreen> createState() => _AdminInstructionDossierScreenState();
}

class _AdminInstructionDossierScreenState extends State<AdminInstructionDossierScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InstructionDossierProvider>().fetchDossiers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Dossiers'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showDossierDialog(),
          ),
        ],
      ),
      body: Consumer<InstructionDossierProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  ElevatedButton(
                    onPressed: () => provider.fetchDossiers(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (provider.dossiers.isEmpty) {
            return const Center(child: Text('Aucun dossier trouvé'));
          }

          return ListView.builder(
            itemCount: provider.dossiers.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final dossier = provider.dossiers[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    dossier.nomdossier,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    dossier.instructions,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showDossierDialog(dossier: dossier),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmation(dossier),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDossierDialog({InstructionDossier? dossier}) {
    final isEditing = dossier != null;
    final nameController = TextEditingController(text: dossier?.nomdossier);
    final instructionsController = TextEditingController(text: dossier?.instructions);
    final codeController = TextEditingController(text: dossier?.codedossier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Modifier Dossier' : 'Ajouter Dossier'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isEditing)
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: 'Code Dossier (5 chars)'),
                  maxLength: 5,
                ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom du Dossier'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: instructionsController,
                decoration: const InputDecoration(labelText: 'Instructions'),
                maxLines: 5,
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
            onPressed: () async {
              if (nameController.text.isEmpty || instructionsController.text.isEmpty || (!isEditing && codeController.text.isEmpty)) {
                return;
              }

              final provider = context.read<InstructionDossierProvider>();
              try {
                if (isEditing) {
                  await provider.updateDossier(
                    dossier.codedossier,
                    dossier.copyWith(
                      nomdossier: nameController.text,
                      instructions: instructionsController.text,
                    ),
                  );
                } else {
                  await provider.addDossier(
                    InstructionDossier(
                      codedossier: codeController.text,
                      nomdossier: nameController.text,
                      instructions: instructionsController.text,
                    ),
                  );
                }
                if (mounted) Navigator.pop(context);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            child: Text(isEditing ? 'Modifier' : 'Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(InstructionDossier dossier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer le dossier "${dossier.nomdossier}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await context.read<InstructionDossierProvider>().deleteDossier(dossier.codedossier);
                if (mounted) Navigator.pop(context);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
