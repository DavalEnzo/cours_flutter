import 'dart:async';

import 'package:cours_flutter/controller/permission_gps.dart';
import 'package:cours_flutter/view/google_carte.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyMapView extends StatefulWidget {
  const MyMapView({super.key});

  @override
  State<MyMapView> createState() => _MyMapViewState();
}

class _MyMapViewState extends State<MyMapView> {
  Stream<Position> _positionStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    _positionStream = Stream.periodic(const Duration(seconds: 1))
        .asyncMap((_) => PermissionGps().init());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: _positionStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.deepOrange,
              strokeWidth: 7,
            ),
          )
          );
        } else if (snapshot.hasError) {
          return const Center(
              child: Text("Erreur de chargement des données",
                  style: TextStyle(color: Colors.white, fontSize: 35)));
        } else {
          Position location = snapshot.data!;
          return CarteGoogle(location: location);
        }
      },
    );
  }
}
