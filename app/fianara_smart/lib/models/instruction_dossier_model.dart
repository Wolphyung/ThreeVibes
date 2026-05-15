// lib/models/instruction_dossier_model.dart

class InstructionDossier {
  final String codedossier;
  final String nomdossier;
  final String instructions;

  InstructionDossier({
    required this.codedossier,
    required this.nomdossier,
    required this.instructions,
  });

  factory InstructionDossier.fromJson(Map<String, dynamic> json) {
    return InstructionDossier(
      codedossier: json['codedossier']?.toString() ?? '',
      nomdossier: json['nomdossier']?.toString() ?? '',
      instructions: json['instructions']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codedossier': codedossier,
      'nomdossier': nomdossier,
      'instructions': instructions,
    };
  }

  InstructionDossier copyWith({
    String? codedossier,
    String? nomdossier,
    String? instructions,
  }) {
    return InstructionDossier(
      codedossier: codedossier ?? this.codedossier,
      nomdossier: nomdossier ?? this.nomdossier,
      instructions: instructions ?? this.instructions,
    );
  }
}
