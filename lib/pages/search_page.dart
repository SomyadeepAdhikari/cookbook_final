import 'dart:convert';
import 'package:cookbook_final/widget/grid_recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:cookbook_final/util/secrets.dart';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Search Recipes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      recipes = getSearchRecipe(value);
                    });
                  },
                  style: theme.textTheme.bodyMedium,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 24,
                    ),
                    hintText: 'Search for recipes...',
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontFamily: 'ArialRounded',
                    ),
                    filled: true,
                    fillColor: colorScheme.secondary.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (textEditingController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                textEditingController.clear();
                                recipes = getSearchRecipe('');
                              });
                            },
                          ),
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: colorScheme.secondary,
                          ),
                          onPressed: () {
                            setState(() {
                              recipes = getSearchRecipe(
                                textEditingController.text,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                      itemCount: data['totalResults'] < 10
                          ? data['totalResults']
                          : 10,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.975,
                          ),
                      itemBuilder: (context, index) {
                        final resultId = data['results'][index]['id'];
                        final name = data['results'][index]['title'];
                        final image = data['results'][index]['image'];
                        return GridRecipeCard(
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
