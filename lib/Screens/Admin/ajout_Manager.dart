import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_reunion_tache/Colors.dart';

class AjoutManager extends StatefulWidget {
  @override
  AjoutManagerState createState() => AjoutManagerState();
}

class AjoutManagerState extends State<AjoutManager> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _prenom = '';
  String _nom = '';
  String _email = '';

  final FirebaseAuth auth = FirebaseAuth.instance;

  // Méthode pour gérer la soumission du formulaire
  Future<void> submitForm() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      try {
        // Récupérer l'ID de l'utilisateur connecté
        final adminId = FirebaseAuth.instance.currentUser?.uid;

        // Création de l'utilisateur apprenant dans Firebase Authentication avec un mot de passe par défaut
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: _email,
          password: '12345678', // Mot de passe par défaut
        );

        // Enregistrement des informations du formateur dans Firestore
        await FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(userCredential.user!.uid)
            .set({
          'prenom': _prenom,
          'nom': _nom,
          'email': _email,
          'role': 'MANAGER', // Rôle par défaut
          'created_at': Timestamp.now(),
          'admin_id': adminId, // ID du formateur connecté
        });

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formateur ajouté avec succès')),
        );

        // Réinitialiser le formulaire après l'enregistrement
        _formKey.currentState?.reset();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/images/logoGwele.png", // Chemin vers le logo
                height: 150,
              ),
              const SizedBox(height: 30),
              const Text(
                "Ajout d'un manager",
                style: TextStyle(
                  fontSize: 24,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      key: const ValueKey('prenom'),
                      decoration: const InputDecoration(
                        labelText: 'Prénom',
                        labelStyle: TextStyle(color: Color(0xffA6A6A6)),
                        prefixIcon: Icon(Icons.person_2_outlined),
                      ),
                      style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                      ),
                      onSaved: (value) {
                        _prenom = value!;
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('nom'),
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        labelStyle: TextStyle(color: Color(0xffA6A6A6)),
                        prefixIcon: Icon(Icons.person_2_outlined),
                      ),
                      style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                      ),
                      onSaved: (value) {
                        _nom = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Veuillez entrer un email valide.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: TextStyle(color: Color(0xffA6A6A6)),
                        prefixIcon: Icon(Icons.mail),
                      ),
                      style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                      ),
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      child: const Text(
                        "Enregistrer",
                        style: TextStyle(color: thirdColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
