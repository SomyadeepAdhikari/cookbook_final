import 'dart:convert';
import 'package:cookbook_final/pages/information.dart';
import 'package:cookbook_final/widget/recipe_card.dart';
import 'package:cookbook_final/util/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplayTile extends StatefulWidget {
  const DisplayTile({super.key});

  @override
  State<DisplayTile> createState() => _DisplayTileState();
}

class _DisplayTileState extends State<DisplayTile> {
  late Future<Map<String,dynamic>> recipes;
  
  @override
  void initState(){
    recipes=getRecipes();
    super.initState();
  }
  Future<Map<String,dynamic>> getRecipes() async{
    try{
      final res = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$spoonacularapi'));
      final data = jsonDecode(res.body);
      if(data['totalresults'] == 0){
        throw 'data not found';
      }
      return data;
    }catch(e){
      throw e.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: recipes, 
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(color:  Colors.green,strokeWidth: 5,));
        }
        if(snapshot.hasError){
          return Center(child: Text('Error',style: Theme.of(context).textTheme.bodyMedium,));
        }
        final data=snapshot.data!;
          return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (context,index){
            final resultId = data['results'][index]['id'];
            final name = data['results'][index]['title'];
            final image = data['results'][index]['image'];
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return Information(name: name, id: resultId, image: image);
                }));
              },
              child: RecipeCard(
                id: resultId,
                image: image,
                title: name
              ),
            );
          }
        );
      } );
  }
}