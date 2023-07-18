import 'package:flutter/material.dart';

import 'my_drawer.dart';

class MyDashBoardView extends StatefulWidget {
  const MyDashBoardView({Key? key}) : super(key: key);

  @override
  _MyDashBoardViewState createState() => _MyDashBoardViewState();
}

class _MyDashBoardViewState extends State<MyDashBoardView> {
  // variable
  int currentIndex = 0;
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
      ),
      backgroundColor: Colors.purple,
      body: bodyPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
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
        ],
      )
    );
  }

  Widget bodyPage()
  {
    return Text("ma page");
  }

}