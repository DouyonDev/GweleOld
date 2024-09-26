import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_reunion_tache/Models/Tache.dart';
import 'package:gestion_reunion_tache/Services/AuthService.dart';
import 'package:gestion_reunion_tache/Services/ReunionService.dart';

import '../Models/Reunion.dart';
import '../Models/Utilisateur.dart';
import '../Screens/Widgets/message_modale.dart';
import 'FichiersService.dart';

class BoutonService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final AuthService authService = AuthService();
  final ReunionService reunionService = ReunionService();
  final FichiersService fichiersService = FichiersService();

  // Bouton pour soumettre le formulaire de connexion
  Future<void> boutonConnexion(GlobalKey<FormState> formKey, String email,
      String password, BuildContext context) async {
    final isValid = formKey.currentState?.validate();
    if (isValid != null && isValid) {
      formKey.currentState?.save();
      try {
        Utilisateur? utilisateur =
            await authService.connexionAvecPassword(email, password, context);

        if (utilisateur != null) {
          // Afficher un message de succès
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const MessageModale(
                title: "Succès",
                content: "Connexion réussie",
              );
            },
          );
        }
      } catch (e) {
        // Gérer les erreurs et afficher une modale d'erreur
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const MessageModale(
              title: "Erreur",
              content: "Problème lors de la connexion.",
            );
          },
        );
        print("le probleme est : ");
        print(e);
      }
    }
  }

  //Bouton pour enregistrer un manager
  Future<void> BtnAjouterManager(GlobalKey<FormState> formKey,
      BuildContext context, String prenom, String nom, String email) async {
    final isValid = formKey.currentState?.validate();
    if (isValid != null && isValid) {
      formKey.currentState?.save();
      try {
        // Récupérer l'ID du formateur connecté
        final adminId = FirebaseAuth.instance.currentUser?.uid;

        // Création de l'utilisateur apprenant dans Firebase Authentication avec un mot de passe par défaut
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: '12345678', // Mot de passe par défaut
        );

        // Enregistrement des informations du formateur dans Firestore
        await FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(userCredential.user!.uid)
            .set({
          'prenom': prenom,
          'nom': nom,
          'email': email,
          'role': 'MANAGER', // Rôle par défaut
          'created_at': Timestamp.now(),
          'admin_id': adminId, // ID du formateur connecté
        });

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formateur ajouté avec succès')),
        );

        // Réinitialiser le formulaire après l'enregistrement
        formKey.currentState?.reset();
      } on FirebaseAuthException catch (e) {
        // Gestion des erreurs d'authentification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }

  //Bouton pour ajouter une réunion
  Future<void> btnAjouterReunion(
      GlobalKey<FormState> formKey,
      BuildContext context,
      String titre,
      String description,
      DateTime dateReunion,
      TimeOfDay heureDebut,
      TimeOfDay heureFin,
      String lieu,
      List<String> participants,
      List<String> decisions,
      List<Tache> tachesAssignees,
      bool isCompleted,
      String lead,
      List<String> documents) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // Créer un objet Réunion
      Reunion nouvelleReunion = Reunion(
        id: '', // L'ID sera généré automatiquement par Firestore
        titre: titre,
        description: description,
        dateReunion: dateReunion,
        heureDebut: heureDebut,
        heureFin: heureFin,
        participants: participants,
        lieu: lieu,
        isCompleted: isCompleted,
        lead: lead,
        decisions: decisions,
        tachesAssignees: tachesAssignees,
        documents: documents, // Ajout des documents
      );

      // Appel au service pour ajouter la réunion
      try {
        await reunionService.ajouterReunion(nouvelleReunion, context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Réunion ajoutée avec succès !')),
        );
        //Navigator.pop(context); // Retour à l'écran précédent
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erreur lors de l\'ajout de la réunion.')),
        );
      }
    }
  }

  //Bouton pour uploader  les documents
  Future<List<String>> selectionnerEtUploaderFichier(
      BuildContext context, List<String> documents) async {

    String nomFichier = await fichiersService.selectionnerFichier();

    if (nomFichier.isNotEmpty && nomFichier != 'Aucun fichier selectionné') {
      // Si un fichier a bien été sélectionné et uploadé
      documents.add(nomFichier); // Ajouter le nom du fichier à la liste

      // Mise à jour de l'interface
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fichier $nomFichier uploadé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      return documents;
    } else if (nomFichier == 'Aucun fichier selectionné') {
      // Si aucun fichier n'a été sélectionné
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun fichier sélectionné'),
          backgroundColor: Colors.orange,
        ),
      );
      return documents;
    } else {
      // En cas d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $nomFichier'),
          backgroundColor: Colors.red,
        ),
      );
      return documents;
    }
  }
}
