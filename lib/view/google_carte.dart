import 'dart:async';

import 'package:cours_flutter/view/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import '../controller/firestore_helper.dart';
import '../global.dart';
import '../model/my_user.dart';
import 'conversation_page.dart';

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
  bool loading = true;
  Timer? _updateMarkersTimer;

  @override
  void initState() {
    super.initState();
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
        infoWindow: InfoWindow(title: "Moi", snippet: "Je suis ici", onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(userId: me.id)));
        }),
      ));
      loading = false;
    }
    );


    _updateMarkersTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      createMarkers();
    });
  }

  @override
  void dispose() {
    _updateMarkersTimer?.cancel();
    super.dispose();
  }

  Future<Uint8List> readNetworkImage(String imageUrl) async {
    final ByteData data =
    await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: camera.zoom.toInt() + 90);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> createMarkers() async {
    for (MyUser friend in friendList) {
      if (friend.coordonnees?["latitude"] != null) {
        Uint8List markerIcon = await readNetworkImage(friend.avatar ?? defaultImage);
        BitmapDescriptor icon = BitmapDescriptor.fromBytes(markerIcon);
        setState(() {
          markers.add(Marker(
            markerId: MarkerId(friend.id),
            position: LatLng(friend.coordonnees!["latitude"], friend.coordonnees!["longitude"]),
            icon: icon,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationPage(user: friend)));
            },
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return GoogleMap(
        initialCameraPosition: camera,
        myLocationButtonEnabled: true,
        markers: markers,
        buildingsEnabled: true,
        myLocationEnabled: true,
        onCameraIdle: () {
          createMarkers();
        },
        onCameraMove: (position) {
          setState(() {
            camera = position;
          });
          createMarkers();
        },
        onMapCreated: (GoogleMapController controller) async {
          controller.setMapStyle("[]");
          controller.setMapStyle(await rootBundle.loadString('lib/map_style.json'));
          completer.complete(controller);
        }
    );
  }
}
