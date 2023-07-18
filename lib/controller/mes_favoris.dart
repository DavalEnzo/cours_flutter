import 'package:flutter/material.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({Key? key}) : super(key: key);

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
  }

  class _MyFavoritesState extends State<MyFavorites> {
    @override
    Widget build(BuildContext context) {
      return const Text("Favoris");
    }
}