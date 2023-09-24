import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/screens/homepage.dart';
import 'package:instagible/styles/themes.dart';

void main() async {
  await dotenv.load(fileName: "assets/configs/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Instangible',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: MyHomePage(title: 'Instangible'),
      ),
    );
  }
}
