import 'dart:convert';
import 'package:cookbook_final/util/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Information extends StatefulWidget {
  final String name;
  final int id;
  final String image;
  const Information(
      {super.key, required this.name, required this.id, required this.image});

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
            'https://api.spoonacular.com/recipes/$newId/information?apiKey=$spoonacularapi'),
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
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.fitWidth,
                    opacity: const AlwaysStoppedAnimation(0.8),
                  )),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.yellow[50],
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.black,)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(child: Text(widget.name,style: Theme.of(context).textTheme.bodyMedium,)),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.limeAccent, borderRadius: BorderRadius.circular(15)),
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text('Ingredients',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                FutureBuilder(
                    future: recipes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Colors.lightGreen));
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error'));
                      }
                      data = snapshot.data!;
                      final ingredients = data?['extendedIngredients'];
                      return Flex(
                        direction: Axis.vertical,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ingredients.length,
                              itemBuilder: (context, index) {
                                final String ingName = ingredients[index]
                                        ['name']
                                    .toString()
                                    .toUpperCase();
                                final String ingAmount = (ingredients[index]
                                        ['measures']['metric']['amount'])
                                    .toString();
                                final String ingMeasuerement =
                                    ingredients[index]['measures']['metric']
                                            ['unitLong']
                                        .toString()
                                        .toUpperCase();
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 5, right: 15),
                                  child: Text(
                                    '${index + 1}. $ingName $ingAmount $ingMeasuerement',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'ArialRounded'),
                                  ),
                                );
                              }),
                        ],
                      );
                    })
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.limeAccent, borderRadius: BorderRadius.circular(15)),
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('Detailed Information',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  FutureBuilder(
                      future: recipes,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.lightGreen));
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            'Error',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ));
                        }
                        data = snapshot.data!;
                        final analyzedInstructions =
                            data?['analyzedInstructions'][0]['steps'];
                        return Flex(
                          direction: Axis.vertical,
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: analyzedInstructions.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, bottom: 5, right: 15),
                                    child: Text(
                                      '${index + 1}. ${analyzedInstructions[index]['step']}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'ArialRounded'),
                                    ),
                                  );
                                }),
                          ],
                        );
                      })
                ],
              ))
        ],
      ),
    ));
  }
}
