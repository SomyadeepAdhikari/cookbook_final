import 'package:cookbook_final/model/favorites_database.dart';
import 'package:cookbook_final/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesDatabase.initialize();
  runApp(ChangeNotifierProvider(
      create: (context) => FavoritesDatabase(), child: const MyApp()));
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
              color: Color.fromARGB(234, 116, 255, 3),
              toolbarHeight: 75,
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(15))),
              shadowColor: Colors.green),
          textTheme: const TextTheme(
              titleMedium: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  fontFamily: 'ArialRounded'),
              bodyMedium: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: 'ArialRounded'),
              bodySmall: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  fontFamily: 'ArialRounded')),
          primaryColor: Colors.lightGreenAccent,
          scaffoldBackgroundColor: Colors.lime.shade100),
      home: const HomePage(),
    );
  }
}
