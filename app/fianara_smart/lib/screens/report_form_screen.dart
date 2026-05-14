import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/report_model.dart';
import '../services/location_service.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportType _selectedType = ReportType.other;
  File? _imageFile;
  final LocationService _locationService = LocationService();

  bool _isLoading = false;
  double? _latitude;
  double? _longitude;
  String _address = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    final location = await _locationService.getCurrentLocationModel();
    if (location != null) {
      setState(() {
        _latitude = location.latitude;
        _longitude = location.longitude;
        _address = location.address ?? 'Position actuelle';
      });
    }

    setState(() => _isLoading = false);
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implémenter la caméra
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir dans la galerie'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implémenter la galerie
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez activer votre localisation'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signalement envoyé avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau signalement'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Type de signalement',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ReportType.values.map((type) {
                final isSelected = _selectedType == type;
                return FilterChip(
                  label: Text(type.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.primary.withValues(alpha: 0.1),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                hintText: 'Ex: Problème d\'éclairage public',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un titre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Décrivez le problème en détail...',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez décrire le problème';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Localisation',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_latitude != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Adresse: $_address'),
                          const SizedBox(height: 4),
                          Text(
                            'Coordonnées: $_latitude, $_longitude',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    else
                      const Text(
                        'Localisation non disponible',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Actualiser'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.photo_camera, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Photo (optionnelle)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showImageSourceDialog,
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('Ajouter une photo'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'ENVOYER LE SIGNALEMENT',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
