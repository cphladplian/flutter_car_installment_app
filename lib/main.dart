import 'package:flutter/material.dart';
import 'package:flutter_car_installment_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const FlutterCarInstallmentApp());
}

class FlutterCarInstallmentApp extends StatelessWidget {
  const FlutterCarInstallmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Installment App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.kanitTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 3,
        ),
      ),
      home: const SplashScreenUi(),
    );
  }
}
