import 'package:cookbook_final/pages/favorite_page.dart';
import 'package:cookbook_final/pages/home_page_body.dart';
import 'package:cookbook_final/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:cookbook_final/util/theme_provider.dart';
import 'package:provider/provider.dart';
import '../components/navigation/glassmorphic_app_bar.dart';
import '../components/navigation/modern_bottom_nav.dart';
import '../components/layout/gradient_background.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    return GradientBackground(
      isDark: isDark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: GlassmorphicAppBar(
          title: 'Discover & Cook',
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
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface.withOpacity(0.8),
              ),
              child: IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.wb_sunny : Icons.dark_mode,
                  color: colorScheme.secondary,
                  size: 24,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: IndexedStack(index: currentPage, children: pages),
        ),
        bottomNavigationBar: ModernBottomNav(
          currentIndex: currentPage,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          items: const [
            ModernBottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
            ),
            ModernBottomNavItem(
              icon: Icons.search_outlined,
              activeIcon: Icons.search_rounded,
              label: 'Search',
            ),
            ModernBottomNavItem(
              icon: Icons.favorite_outline,
              activeIcon: Icons.favorite_rounded,
              label: 'Favorite',
            ),
          ],
        ),
      ),
    );
  }
}
