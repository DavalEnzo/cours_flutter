import 'dart:async';

import 'package:cours_flutter/view/conversation_page.dart';
import 'package:cours_flutter/view/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

import '../controller/firestore_helper.dart';
import '../global.dart';
import '../model/my_user.dart';

class MyMapView extends StatefulWidget {
  const MyMapView({super.key});

  @override
  State<MyMapView> createState() => _MyMapViewState();
}

class _MyMapViewState extends State<MyMapView> {
  // variable
  Completer<GoogleMapController> completer = Completer();
  List<MyUser> friendList = [];
  List<Marker> markers = [];
  LocationData? myPosition;
  late CameraPosition camera;

  getMyLocation() async {
    Location location = Location();

    LocationData value = await location.getLocation();
    setState(() {
      myPosition = value;
      camera = CameraPosition(
        target: LatLng(myPosition!.latitude!, myPosition!.longitude!),
        zoom: 13,
      );
    });
  }
  Timer? _refreshTimer; // Declare the Timer variable.

  @override
  void initState() {
    super.initState();
    getMyLocation().then((_) {
      getFriendsLocation();
    });

    // Start the periodic refresh and store the Timer in the _refreshTimer variable.
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      _refreshFriendList();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid calling setState after dispose.
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _refreshFriendList() {
    setState(() {
      friendList.clear(); // Clear the existing friendList.
      getFriendsLocation(); // Fetch the updated friendList.
    });
  }

  Future<void> getFriendsLocation() async {
    for (String index in me.favoris!) {
      MyUser user = await FirestoreHelper().getUser(index);
      setState(() {
        friendList.add(user);
      });
    }
  }

  Future<Uint8List> readNetworkImage(String imageUrl) async {
    final ByteData data =
    await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: camera.zoom.toInt() + 90);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  createMarkers() async {
    List<MyUser> friendListCopy = List.from(friendList); // Create a copy of the friendList.
    List<Marker> updatedMarkers = []; // Create a new list for markers.

    for (MyUser friend in friendListCopy) {
      if (friend.coordonnees != null) {
        Uint8List markerIcon =
        await readNetworkImage(friend.avatar ?? defaultImage);
        updatedMarkers.add(
          Marker(
            markerId: MarkerId(friend.id),
            position: LatLng(friend.coordonnees!["latitude"], friend.coordonnees!["longitude"]),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationPage(user: friend)));
            },
          ),
        );
      }
    }

    // Assign the new list of markers to the markers variable.
    setState(() {
      markers = updatedMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    createMarkers();
    return Scaffold(
      body: myPosition == null
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: Colors.deepOrange,
          strokeWidth: 7,
        ),
      )
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(myPosition!.latitude!, myPosition!.longitude!),
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: MarkerId(me.id),
            position: LatLng(myPosition!.latitude!, myPosition!.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(title: "Moi", snippet: "Je suis ici", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(userId: me.id)));
            }),
          ),
          ...markers
        },
        buildingsEnabled: true,
        myLocationEnabled: true,
        onCameraMove: (position) {
          setState(() {
            camera = position;
          });
        },
        onMapCreated: (GoogleMapController controller) async {
          controller.setMapStyle("[]");
          controller.setMapStyle(
              await rootBundle.loadString('lib/map_style.json'));
          completer.complete(controller);
        },
      ),
    );
  }
}
