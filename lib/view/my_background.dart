import 'package:flutter/material.dart';

import '../controller/custom_path.dart';

class MyBackground extends StatefulWidget {
  const MyBackground({super.key});

  @override
  State<MyBackground> createState() => _MyBackgroundState();
}

class _MyBackgroundState extends State<MyBackground> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomPath(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://w0.peakpx.com/wallpaper/201/414/HD-wallpaper-mountain-landscape-balloon-material-mountains-scenery-thumbnail.jpg"),
            fit: BoxFit.cover,
          ),
        )
      )
    );
  }
}
