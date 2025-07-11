import 'package:cookbook_final/model/favorites_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatefulWidget {
  final int id;
  final String title;
  final String image;
  const RecipeCard({
    super.key,
    required this.id,
    required this.title,
    required this.image,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isfav = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(1, 1)),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(0),
        width: (MediaQuery.of(context).size.width - 20),
        height: 210, // <-- Add a fixed height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover, // Modern look
                  width: double.infinity,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isfav = !isfav;
                      if (isfav) {
                        context.read<FavoritesDatabase>().addFavorite(
                          widget.title,
                          widget.id,
                          widget.image,
                        );
                      } else {
                        context.read<FavoritesDatabase>().deleteId(widget.id);
                      }
                    });
                  },
                  color: isfav ? Colors.red : Colors.black38,
                  icon: const Icon(Icons.favorite),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
