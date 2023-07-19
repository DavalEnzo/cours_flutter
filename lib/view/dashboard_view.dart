import 'package:flutter/material.dart';

import '../controller/all_users.dart';
import '../controller/mes_favoris.dart';
import '../global.dart';
import 'my_drawer.dart';
import 'my_map_view.dart';

class MyDashBoardView extends StatefulWidget {
  const MyDashBoardView({Key? key}) : super(key: key);

  @override
  _MyDashBoardViewState createState() => _MyDashBoardViewState();
}

class _MyDashBoardViewState extends State<MyDashBoardView> {
  // variable
  int currentIndex = 0;
  String title = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar totalement transparente
      // drawer = hamburger menu
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.72,
        height: MediaQuery.of(context).size.height,
        color: Colors.amber,
        child: const MyDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title),
      ),
      backgroundColor: Colors.purple,
      body: bodyPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;

            switch (currentIndex) {
              case 0:
                title = "Utilisateurs";
                break;
              case 1:
                title = "Mes amis";
                break;
              case 2:
                title = "Carte";
                break;
              default:
                title = "Problème d'affichage";
            }
          });
        },
        elevation: 1,
        selectedItemColor: Colors.lightGreen,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Utilisateurs"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Mes amis"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Carte"
          ),
        ],
      )
    );
  }

  Widget bodyPage()
  {
    switch(currentIndex)
    {
      case 0:
        return const AllUsers();
      case 1:
        return const MyFavorites();
      case 2:
        return const MyMapView();
      default:
        return Text("Problème d'affichage");
    }
  }

}