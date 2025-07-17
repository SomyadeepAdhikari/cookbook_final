import 'package:cookbook_final/model/favorites_database.dart';
import 'package:cookbook_final/pages/home_page.dart';
import 'package:cookbook_final/util/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  await FavoritesDatabase.initialize();

  // Create database instance and open the box
  final favoritesDb = FavoritesDatabase();
  await favoritesDb.openBox();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: favoritesDb),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'CookBook',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkMode
              ? themeProvider.darkTheme
              : themeProvider.lightTheme,
          home: const HomePage(),
        );
      },
    );
  }
}
