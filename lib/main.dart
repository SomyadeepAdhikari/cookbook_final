import 'package:cookbook_final/model/favorites_database.dart';
import 'package:cookbook_final/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesDatabase.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'ArialRounded',
        appBarTheme: const AppBarTheme(
          color: Color(0xFFFAF1E6),
          toolbarHeight: 75,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          shadowColor: Color(0xFF99BC85), // Muted Brown
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            fontFamily: 'ArialRounded',
            color: Colors.blueGrey
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'ArialRounded',
          ),
          bodySmall: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            fontFamily: 'ArialRounded',
            color: Colors.black87
          ),
        ),
        primaryColor: Color(0xFFFDFAF6), 
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFFFFA726), // Warm Orange
          error: Color(0xFFD32F2F), // Deep Red
        ),
        scaffoldBackgroundColor: Color(0xFFE4EFE7), 
      ),
      home: const HomePage(),
    );
  }
}
