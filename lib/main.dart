import 'package:flutter/material.dart';
import '../screens/Home.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 91, 56, 187),
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 91, 56, 187),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )
        )
      )
    );
  }
}
