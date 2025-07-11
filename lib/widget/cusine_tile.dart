import 'package:flutter/material.dart';

class CuisineTile extends StatelessWidget {
  final String cuisineName;
  final String? selectedcuisine;
  const CuisineTile({super.key, required this.cuisineName,this.selectedcuisine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 5),
        decoration: BoxDecoration(boxShadow: const <BoxShadow>[
          BoxShadow(
              color:  Colors.grey, blurRadius: 4, offset: Offset(1.0, 1.0))
        ], borderRadius: BorderRadius.circular(100), 
        color: selectedcuisine==cuisineName ? Colors.limeAccent:Theme.of(context).primaryColor),
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(cuisineName,style: const TextStyle(fontFamily: 'ArielRounded',fontWeight: FontWeight.w500,fontSize: 50,color: Colors.black),),
            ),
          ),
        ),
      ),
    );
  }
}
