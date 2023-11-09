import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  debugProfileBuildsEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const HomePage(),
    );
  }
}
