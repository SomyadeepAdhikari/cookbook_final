import 'package:cookbook_final/pages/favorite_page.dart';
import 'package:cookbook_final/pages/home_page_body.dart';
import 'package:cookbook_final/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:cookbook_final/util/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = const [HomePageBody(), SearchPage(), FavoritePage()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: AppBar(
            backgroundColor: colorScheme.primary,
            elevation: 6,
            centerTitle: true,
            leading: Container(
              margin: const EdgeInsets.only(left: 15, right: 5),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/Logo.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              'Discover & Cook',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 1.1,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.wb_sunny : Icons.dark_mode,
                  color: colorScheme.secondary,
                  size: 28,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
              /* IconButton(
                icon: Icon(
                  Icons.account_circle_rounded,
                  color: colorScheme.secondary,
                  size: 32,
                ),
                onPressed: () {
                  // TODO: Implement profile/settings navigation
                },
              ),*/
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(index: currentPage, children: pages),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 8,
          borderRadius: BorderRadius.circular(60),
          shadowColor: colorScheme.secondary.withValues(alpha: .18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: BottomNavigationBar(
              selectedItemColor: colorScheme.secondary,
              unselectedItemColor: colorScheme.onSurface.withValues(alpha: .6),
              backgroundColor: colorScheme.primary.withValues(alpha: .95),
              iconSize: 30,
              currentIndex: currentPage,
              onTap: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Icon(Icons.home_rounded),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Icon(Icons.search_rounded),
                  ),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Icon(Icons.favorite_rounded),
                  ),
                  label: 'Favorite',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
