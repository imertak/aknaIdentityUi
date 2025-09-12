import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'layouts/main_layout.dart';
import 'providers/navigation_provider.dart';
import 'providers/user_data_provider.dart';
import 'models/user_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = UserDataProvider();
            provider.setUserData("Mert", UserType.carrier);
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Akna UI',
        home: MainLayout(),
      ),
    );
  }
}
