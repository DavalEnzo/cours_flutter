import 'package:flutter/material.dart';

class MyDashBoardView extends StatefulWidget {
  const MyDashBoardView({Key? key}) : super(key: key);

  @override
  _MyDashBoardViewState createState() => _MyDashBoardViewState();
}

class _MyDashBoardViewState extends State<MyDashBoardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar totalement transparente
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage()
  {
    return Text("ma page");
  }

}