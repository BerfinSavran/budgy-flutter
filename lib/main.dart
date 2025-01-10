import 'package:budgy/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Budgy());
}

class Budgy extends StatelessWidget {
  const Budgy({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Budgy",
      home: LoginScreen(),
    );
  }
}
