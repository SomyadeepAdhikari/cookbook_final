import 'dart:convert';
import 'package:cookbook_final/pages/information.dart';
import 'package:cookbook_final/widget/recipe_card.dart';
import 'package:cookbook_final/util/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DisplayTile extends StatefulWidget {
  const DisplayTile({super.key});

  @override
  State<DisplayTile> createState() => _DisplayTileState();
}

class _DisplayTileState extends State<DisplayTile> {
  late Future<Map<String, dynamic>> recipes;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void initState() {
    recipes = getRecipes();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getRecipes() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?apiKey=$spoonacularapi',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['totalresults'] == 0) {
        throw 'data not found';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return FutureBuilder(
      future: recipes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: colorScheme.secondary,
              strokeWidth: 5,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error', style: theme.textTheme.bodyMedium),
          );
        }
        final data = snapshot.data!;
        final itemCount = data['results'].length < 6
            ? data['results'].length
            : 6;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 240,
              child: PageView.builder(
                controller: _pageController,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  final resultId = data['results'][index]['id'];
                  final name = data['results'][index]['title'];
                  final image = data['results'][index]['image'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Information(
                              name: name,
                              id: resultId,
                              image: image,
                            ),
                          ),
                        );
                      },
                      child: RecipeCard(
                        id: resultId,
                        image: image,
                        title: name,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SmoothPageIndicator(
              controller: _pageController,
              count: itemCount,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 16,
                activeDotColor: colorScheme.secondary,
                dotColor: colorScheme.secondary.withOpacity(0.2),
              ),
            ),
          ],
        );
      },
    );
  }
}
