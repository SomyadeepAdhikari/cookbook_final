import 'package:cookbook_final/globals.dart';
import 'package:cookbook_final/pages/cuisines_page.dart';

import 'cusine_tile.dart';
import 'package:flutter/material.dart';

class CuisinesPageChip extends StatefulWidget {
  final String selectedCuisine;
  const CuisinesPageChip({super.key, required this.selectedCuisine});

  @override
  State<CuisinesPageChip> createState() => _CuisinesPageChipState();
}

class _CuisinesPageChipState extends State<CuisinesPageChip> {
  String selectedCuisine=' ';
  @override
  void initState() {
    selectedCuisine=widget.selectedCuisine;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (MediaQuery.of(context).size.width / 8),
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedCuisine=cuisines[index];
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context){
                          return CuisinesPage(cuisineSearch: selectedCuisine);
                        }));
                    },
                    child: CuisineTile(cuisineName: cuisines[index],selectedcuisine: selectedCuisine,)
                  );
                }, 
                childCount: cuisines.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.35)
                )
          ],
        ));
  }
}