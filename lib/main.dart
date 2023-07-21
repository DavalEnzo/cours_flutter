// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:cours_flutter/controller/my_permission.dart';
import 'package:cours_flutter/controller/permission_gps.dart';
import 'package:cours_flutter/view/loading_view.dart';
import 'package:cours_flutter/view/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ne pas oublier d'importer le package firebase_core pour initialiser le lien avec Firebase,
// le package firebase_auth pour l'authentification et le package cloud_firestore pour la base de données
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'controller/firestore_helper.dart';
import 'firebase_options.dart';
import 'global.dart';

void fetchBackground(context) async {
  // Perform your background task here
  print("Background fetch executed");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  MyPermissionPhoto().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<Position?> getUserCurrentLocation() async {
    try {
      PermissionGps().init();
      var gpsEnabled = await Permission.location.serviceStatus.isEnabled;
      if(gpsEnabled) {
        var position = await Geolocator.getCurrentPosition();
        return position;
      }
    } catch (e) {
      print(e);
    }

    return await Geolocator.getCurrentPosition();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getUserCurrentLocation();
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      fetchBackground(context);
      var gpsEnabled = await Permission.location.serviceStatus.isEnabled;
      if(me.id != "" && !gpsEnabled) {
        me.coordonnees = {
          "latitude": me.coordonnees?["latitude"],
          "longitude": me.coordonnees?["longitude"]
        };
        Map<String, dynamic> map = {
          "coordonnees": me.coordonnees
        };
        FirestoreHelper().updateUser(me.id, map);
      }
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.purple,
      ),
      home: const MyLoading(),
      debugShowCheckedModeBanner: false,
    );
  }
}