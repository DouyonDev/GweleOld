class Utilisateur {
  final String id;
  final String nom;
  final String prenom;
  final String role;
  final String email;
  final List<String> tachesAssignees;
  final List<String> reunions;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
    required this.email,
    required this.tachesAssignees,
    required this.reunions,
  });

  // Méthode pour convertir un document Firestore en instance de Utilisateur
  factory Utilisateur.fromDocument(Map<String, dynamic> doc, String docId) {
    return Utilisateur(
      id: docId,
      nom: doc['nom'] ?? '',
      prenom: doc['prenom'] ?? '',
      role: doc['role'] ?? '',
      email: doc['email'] ?? '',
      tachesAssignees: List<String>.from(doc['tachesAssignees'] ?? []),
      reunions: List<String>.from(doc['reunions'] ?? []),
    );
  }

  // Méthode pour convertir une instance d'Utilisateur en format Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'role': role,
      'email': email,
      'tachesAssignees': tachesAssignees,
      'reunions': reunions,
    };
  }
}
