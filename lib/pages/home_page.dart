import 'package:cookbook_final/pages/favorite_page.dart';
import 'package:cookbook_final/pages/home_page_body.dart';
import 'package:cookbook_final/pages/search_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override/*  */
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage=0;
  List<Widget> pages=const [HomePageBody(),SearchPage(),FavoritePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/Logo.png',height: 100,),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor:Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        iconSize: 35,
        currentIndex: currentPage,
        onTap: (value){
          setState(() {
            currentPage=value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favorite')
      ],),
    );
  }
}