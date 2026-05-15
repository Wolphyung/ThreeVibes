// lib/providers/instruction_dossier_provider.dart
import 'package:flutter/material.dart';
import '../models/instruction_dossier_model.dart';
import '../services/instruction_dossier_service.dart';

class InstructionDossierProvider with ChangeNotifier {
  List<InstructionDossier> _dossiers = [];
  bool _isLoading = false;
  String? _error;

  List<InstructionDossier> get dossiers => _dossiers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDossiers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dossiers = await InstructionDossierService.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDossier(InstructionDossier dossier) async {
    try {
      final newDossier = await InstructionDossierService.create(dossier);
      _dossiers.add(newDossier);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> updateDossier(String id, InstructionDossier dossier) async {
    try {
      final updatedDossier = await InstructionDossierService.update(id, dossier);
      final index = _dossiers.indexWhere((d) => d.codedossier == id);
      if (index != -1) {
        _dossiers[index] = updatedDossier;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> deleteDossier(String id) async {
    try {
      await InstructionDossierService.delete(id);
      _dossiers.removeWhere((d) => d.codedossier == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }
}
