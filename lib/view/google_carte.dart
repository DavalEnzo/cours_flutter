import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

import '../controller/firestore_helper.dart';
import '../global.dart';
import '../model/my_user.dart';

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
  List<MyUser> friendList = [];
  final Set<Marker> markers = {};
  @override
  void initState() {
    for (String index in me.favoris!) {
      FirestoreHelper().getUser(index).then((value) {
        setState(() {
          friendList.add(value);
        });
      });
    }
    camera = CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: 13,
    );
    setState(() {
      markers.add(
          Marker(
        markerId: MarkerId(me.id),
        position: LatLng(widget.location.latitude, widget.location.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: me.fullName),
      ));
    });
  }

  Future<BitmapDescriptor> getMarkerIconFromUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return BitmapDescriptor.fromBytes(bytes, size: const Size(20, 20));
    } else {
      // If there is an error or the image cannot be loaded, return a default icon.
      return BitmapDescriptor.defaultMarker;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition: camera,
        myLocationButtonEnabled: true,
        markers: markers,
        buildingsEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (control) async {
          String newStyle = await DefaultAssetBundle.of(context)
              .loadString('lib/map_style.json');
          control.setMapStyle(newStyle);
          for (MyUser friend in friendList) {
            if (friend.coordonnees?["latitude"] != null) {
              String? imageUrl = friend.avatar; // Replace with the actual field in your database that holds the image URL.
              BitmapDescriptor icon = await getMarkerIconFromUrl(imageUrl!);
              setState(() {
                markers.add(Marker(
                  markerId: MarkerId(friend.id),
                  position: LatLng(friend.coordonnees!["latitude"], friend.coordonnees!["longitude"]),
                  icon: icon,
                  infoWindow: InfoWindow(title: friend.fullName),
                ));
              });
            }
          }

          completer.complete(control);
        });
  }
}
