import 'dart:convert';

import 'package:cookbook_final/pages/search_page.dart';
import 'package:cookbook_final/widget/cuisines_page_chip.dart';
import 'package:cookbook_final/widget/grid_recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:cookbook_final/util/secrets.dart';
import 'package:http/http.dart' as http;
class CuisinesPage extends StatefulWidget {
  final String cuisineSearch;
  const CuisinesPage({super.key, required this.cuisineSearch});

  @override
  State<CuisinesPage> createState() => _CuisinesPageState();
}

class _CuisinesPageState extends State<CuisinesPage> {
  late Future<Map<String,dynamic>> recipes;
  late String searchRecipe='';
  @override
  void initState(){
    searchRecipe=widget.cuisineSearch;
    recipes=getSearchRecipe(searchRecipe);
    super.initState();
  }
  Future<Map<String,dynamic>> getSearchRecipe(String? search) async{
    search == 'All'? '':search;
    try{
      final res=await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$spoonacularapi&query=$search'
      ));
      final data=jsonDecode(res.body);
      if(data['totalresults']==0){
        throw 'No Results Found';
      }
      return data;
    }catch(e){
      throw 'Connection Error';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Image.asset('assets/images/Logo.png',height: 100,),
        centerTitle: true,
        actions: [IconButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return  const SafeArea(child: SearchPage());
            }));
          }, 
          icon: const Icon(Icons.search))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CuisinesPageChip(selectedCuisine: searchRecipe),
          ),
          Expanded(
            child: FutureBuilder(
              future: recipes,
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(color: Colors.lightGreen));
                  }
                  if(snapshot.hasError){
                    return const Center(child: Text('Error'));
                  }
                  final data=snapshot.data!;
                  return GridView.builder(
                    itemCount: data['totalResults']<10? data['totalResults']:10,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.975),
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
            )
          )
        ],
      ),
    );
  }
}