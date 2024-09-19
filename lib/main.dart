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
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Enlever le bandeau "DEBUG"
      theme: ThemeData(
        primaryColor: primaryColor, // Couleur principale
        hintColor: secondaryColor, // Couleur d'accent
      ),
      home: Bienvenue(),
    );
  }
}
