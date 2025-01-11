import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importando o Riverpod
import '../screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Marcando o construtor como const

  @override
  Widget build(BuildContext context) {
    return ProviderScope( // Envolvendo o aplicativo com o ProviderScope
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Home(),
        theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 91, 56, 187),
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          )
        ),
      ),
    );
  }
}
