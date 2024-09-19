import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Utilisateur.dart';

class UtilisateurService {
  final CollectionReference utilisateurCollection =
      FirebaseFirestore.instance.collection('utilisateurs');

  // Ajouter un utilisateur
  Future<void> ajouterUtilisateur(Utilisateur utilisateur) async {
    try {
      await utilisateurCollection.doc(utilisateur.id).set({
        'nom': utilisateur.nom,
        'prenom': utilisateur.prenom,
        'role': utilisateur.role,
        'email': utilisateur.email,
        'tachesAssignees': utilisateur.tachesAssignees,
        'reunions': utilisateur.reunions,
      });
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'utilisateur: $e');
      throw e; // Propager l'erreur pour la gestion à un niveau supérieur
    }
  }

  // Récupérer une liste d'utilisateurs
  Stream<List<Utilisateur>> listeUtilisateurs() {
    try {
      return utilisateurCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Utilisateur(
            id: doc.id,
            nom: doc['nom'],
            prenom: doc['prenom'],
            role: doc['role'],
            email: doc['email'],
            tachesAssignees: List<String>.from(doc['tachesAssignees']),
            reunions: List<String>.from(doc['reunions']),
          );
        }).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs: $e');
      rethrow; // Propager l'erreur
    }
  }

  // Mise à jour d'un utilisateur
  Future<void> mettreAJourUtilisateur(Utilisateur utilisateur) async {
    try {
      await utilisateurCollection.doc(utilisateur.id).update({
        'nom': utilisateur.nom,
        'prenom': utilisateur.prenom,
        'role': utilisateur.role,
        'email': utilisateur.email,
        'tachesAssignees': utilisateur.tachesAssignees,
        'reunions': utilisateur.reunions,
      });
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'utilisateur: $e');
      throw e;
    }
  }

  // Suppression d'un utilisateur
  Future<void> supprimerUtilisateur(String id) async {
    try {
      await utilisateurCollection.doc(id).delete();
    } catch (e) {
      print('Erreur lors de la suppression de l\'utilisateur: $e');
      throw e;
    }
  }
}
