import 'package:flutter/material.dart';

import 'db/mongo_database.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await MongoDatabase.connect();
    print("Conectado a MongoDB");
  } catch (e) {
    print("Error al conectar MongoDB: $e");
    print("La aplicación continuará sin base de datos");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rincón Literario',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      home: const HomePage(),
    );
  }
}