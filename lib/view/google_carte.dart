import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarteGoogle extends StatefulWidget {
  Position location;

  CarteGoogle({super.key, required this.location});

  @override
  State<CarteGoogle> createState() => _CarteGoogleState();
}

class _CarteGoogleState extends State<CarteGoogle> {
  // variable
  Completer<GoogleMapController> completer = Completer();
  late CameraPosition camera;

  @override
  void initState() {
    camera = CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: 18,
    );
  }

  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition: camera,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId("myPosition"),
            position: LatLng(widget.location.latitude, widget.location.longitude),
            infoWindow: const InfoWindow(title: "Ma position"),
          )
        },
        buildingsEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (control) async {
          String newStyle = await DefaultAssetBundle.of(context).loadString('lib/map_style.json');
          control.setMapStyle(newStyle);
          completer.complete(control);
        });
  }
}
