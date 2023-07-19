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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: PermissionGps().init(),
      builder: (context, snap){
        if(snap.data == null){
          return const Center(child: Text("Aucune donnée", style: TextStyle(color: Colors.white, fontSize: 35)));
        } else {
          Position location = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: CarteGoogle(location: location),
          );
        }
      },
    );
  }
}
