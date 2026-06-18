import 'package:flutter/material.dart';

import 'db/mongo_database.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MongoDatabase.connect();
  print("Conectado a MongoDB");

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