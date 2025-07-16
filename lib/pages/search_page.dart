import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cookbook_final/util/secrets.dart';
import 'package:http/http.dart' as http;
import '../components/inputs/glassmorphic_search_bar.dart';
import '../components/cards/modern_recipe_card.dart';
import '../theme/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textEditingController = TextEditingController();
  final border = OutlineInputBorder(
    borderSide: const BorderSide(width: 2, color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
  );

  late Future<Map<String, dynamic>> recipes;
  @override
  void initState() {
    recipes = getSearchRecipe('');
    super.initState();
  }

  Future<Map<String, dynamic>> getSearchRecipe(String? search) async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?apiKey=$spoonacularapi&query=$search',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['totalresults'] == 0) {
        throw 'No Results Found';
      }
      return data;
    } catch (e) {
      throw 'Connection Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Search Recipes',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkOnSurface
                      : AppColors.lightOnSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Modern Search Bar
            GlassmorphicSearchBar(
              controller: textEditingController,
              hintText: 'Search for delicious recipes...',
              onSubmitted: (value) {
                setState(() {
                  recipes = getSearchRecipe(value);
                });
              },
              onChanged: (value) {
                // Optional: Implement real-time search
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FutureBuilder(
                  future: recipes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.secondary,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'No recipes found. Try another search!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      );
                    }
                    final data = snapshot.data!;
                    if (data['totalResults'] == 0 || data['results'] == null) {
                      return Center(
                        child: Text(
                          'No recipes found. Try another search!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data['totalResults'] < 10
                          ? data['totalResults']
                          : 10,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.9,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final resultId = data['results'][index]['id'];
                        final name = data['results'][index]['title'];
                        final image = data['results'][index]['image'];
                        return ModernRecipeCard(
                          id: resultId,
                          image: image,
                          title: name,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
