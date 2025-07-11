import 'dart:convert';
import 'package:cookbook_final/util/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Information extends StatefulWidget {
  final String name;
  final int id;
  final String image;
  const Information({
    super.key,
    required this.name,
    required this.id,
    required this.image,
  });

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  Map<String, dynamic>? data;
  late Future<Map<String, dynamic>> recipes;

  @override
  void initState() {
    recipes = getRecipes();
    super.initState();
  }

  Future<Map<String, dynamic>> getRecipes() async {
    final newId = widget.id;
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/$newId/information?apiKey=$spoonacularapi',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['totalResults'] == 0) {
        throw 'No result Found';
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
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Image with overlay and back button
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: Image.network(
                      widget.image,
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.2),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: colorScheme.secondary.withOpacity(0.15),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 24,
                    right: 24,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          shadows: [
                            Shadow(blurRadius: 8, color: Colors.black26),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Ingredients Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: colorScheme.secondary.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_basket,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Ingredients',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FutureBuilder(
                          future: recipes,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: colorScheme.secondary,
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Text(
                                'Could not load ingredients.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                              );
                            }
                            data = snapshot.data!;
                            final ingredients = data?['extendedIngredients'];
                            if (ingredients == null || ingredients.isEmpty) {
                              return Text('No ingredients found.');
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ingredients.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 8,
                                color: Colors.transparent,
                              ),
                              itemBuilder: (context, index) {
                                final ing = ingredients[index];
                                final String ingName = ing['name']
                                    .toString()
                                    .toUpperCase();
                                final String ingAmount =
                                    ing['measures']['metric']['amount']
                                        .toString();
                                final String ingMeasurement =
                                    ing['measures']['metric']['unitLong']
                                        .toString()
                                        .toUpperCase();
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '• ',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$ingName $ingAmount $ingMeasurement',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Instructions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: colorScheme.secondary.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.menu_book, color: colorScheme.secondary),
                            const SizedBox(width: 8),
                            Text(
                              'Instructions',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FutureBuilder(
                          future: recipes,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: colorScheme.secondary,
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Text(
                                'Could not load instructions.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                              );
                            }
                            data = snapshot.data!;
                            final steps =
                                data?['analyzedInstructions']?[0]?['steps'];
                            if (steps == null || steps.isEmpty) {
                              return Text('No instructions found.');
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: steps.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 8,
                                color: Colors.transparent,
                              ),
                              itemBuilder: (context, index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: colorScheme.secondary,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        steps[index]['step'],
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
