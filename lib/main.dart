import 'package:akna_ui/loginScreen.dart';
import 'package:akna_ui/mainDashboardScreen.dart';
import 'package:flutter/material.dart';

// Uygulama giriş noktası
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Uygulama',
      home: MainDashboardScreen(
        userType: "Carrier",
        userName: "Mert",
      ), // Ana ekran olarak MainDashboardScreen kullanılıyor
    );
  }
}
