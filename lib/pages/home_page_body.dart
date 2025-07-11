import 'package:cookbook_final/widget/categories_chip.dart';
import 'package:cookbook_final/widget/display_tile.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Today\'s Top Pick', style: Theme.of(context).textTheme.titleMedium,),
          ),
          const SizedBox(height: 10),
          SizedBox(height: MediaQuery.of(context).size.width-40,child:const  DisplayTile()),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Cuisines',style: Theme.of(context).textTheme.titleMedium,),
          ),
          const SizedBox(height: 10),
          const CategoriesChip()
        ],
      );
  }
}