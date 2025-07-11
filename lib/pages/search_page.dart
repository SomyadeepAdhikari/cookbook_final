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
  final border=OutlineInputBorder(borderSide: const BorderSide(
                width: 2,
                color: Colors.grey
              ),
              borderRadius:BorderRadius.circular(10)
              );

  late Future<Map<String,dynamic>> recipes;
  @override
  void initState(){
    recipes=getSearchRecipe('');
    super.initState();
  }
  Future<Map<String,dynamic>> getSearchRecipe(String? search) async{
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  recipes=getSearchRecipe(value);
                });
              },
              style: Theme.of(context).textTheme.bodyMedium,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'Search',hintStyle: const TextStyle(color: Colors.black38,fontFamily: 'ArialRounded'),
                focusedBorder: border,
                enabledBorder: border,
                suffixIcon: IconButton(onPressed: (){},icon: const Icon(Icons.search),)
              ), 
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
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
                  //scrollDirection: Axis.horizontal,
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
              }),
            ),
          ),
        ],
      ),
    );
  }
}