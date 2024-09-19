import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Reunion.dart';

class ReunionService {
  final CollectionReference reunionCollection =
      FirebaseFirestore.instance.collection('reunions');

  // Ajouter une réunion
  Future<void> ajouterReunion(Reunion reunion) async {
    try {
      await reunionCollection.doc(reunion.id).set({
        'titre': reunion.titre,
        'description': reunion.description,
        'dateReunion': reunion.dateReunion.toIso8601String(),
        'participants': reunion.participants,
        'lieu': reunion.lieu,
        'isCompleted': reunion.isCompleted,
        'lead': reunion.lead,
        'decisions': reunion.decisions,
        'tachesAssignees':
            reunion.tachesAssignees.map((tache) => tache.id).toList(),
      });
    } catch (e) {
      print('Erreur lors de l\'ajout de la réunion: $e');
      throw e;
    }
  }

  // Récupérer une liste de réunions
  Stream<List<Reunion>> listeReunions() {
    try {
      return reunionCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Reunion(
            id: doc.id,
            titre: doc['titre'],
            description: doc['description'],
            dateReunion: DateTime.parse(doc['dateReunion']),
            participants: List<String>.from(doc['participants']),
            lieu: doc['lieu'],
            isCompleted: doc['isCompleted'],
            lead: doc['lead'],
            decisions: List<String>.from(doc['decisions']),
            tachesAssignees: [], // Assurez-vous de gérer les tâches assignées séparément si nécessaire
          );
        }).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des réunions: $e');
      rethrow;
    }
  }

  // Mise à jour d'une réunion
  Future<void> mettreAJourReunion(Reunion reunion) async {
    try {
      await reunionCollection.doc(reunion.id).update({
        'titre': reunion.titre,
        'description': reunion.description,
        'dateReunion': reunion.dateReunion.toIso8601String(),
        'participants': reunion.participants,
        'lieu': reunion.lieu,
        'isCompleted': reunion.isCompleted,
        'lead': reunion.lead,
        'decisions': reunion.decisions,
        'tachesAssignees':
            reunion.tachesAssignees.map((tache) => tache.id).toList(),
      });
    } catch (e) {
      print('Erreur lors de la mise à jour de la réunion: $e');
      throw e;
    }
  }

  // Suppression d'une réunion
  Future<void> supprimerReunion(String id) async {
    try {
      await reunionCollection.doc(id).delete();
    } catch (e) {
      print('Erreur lors de la suppression de la réunion: $e');
      throw e;
    }
  }
}
