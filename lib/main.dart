import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Colors.dart';
import 'Screens/bienvenue.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Affiche un indicateur de chargement pendant l'initialisation
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Erreur lors de l\'initialisation de Firebase'), // Affiche un message d'erreur
              ),
            ),
          );
        }
        // Si tout va bien, l'application démarre normalement
        return MaterialApp(
          debugShowCheckedModeBanner: false, // Enlever le bandeau "DEBUG"
          theme: ThemeData(
            primaryColor: primaryColor, // Couleur principale
            hintColor: secondaryColor,  // Couleur d'accent
          ),
          home: Bienvenue(),  // Ecran de bienvenue
        );
      },
    );
  }
}
