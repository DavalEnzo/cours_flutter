// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cours_flutter/controller/my_permission.dart';
import 'package:cours_flutter/view/loading_view.dart';
import 'package:cours_flutter/view/register_view.dart';
import 'package:flutter/material.dart';
// ne pas oublier d'importer le package firebase_core pour initialiser le lien avec Firebase,
// le package firebase_auth pour l'authentification et le package cloud_firestore pour la base de données
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';

const taskName = "fetchBackground";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (taskName){
      case "fetchBackground":
        fetchBackground();
      break;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  await Workmanager().registerPeriodicTask(
    "1", // A unique name for the task
    "fetchBackground", // This should be the name of your background task function
    frequency: const Duration(hours: 1),
    existingWorkPolicy: ExistingWorkPolicy.append// Set the frequency of the task (e.g., every hour)
  );
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  MyPermissionPhoto().init();
  runApp(const MyApp());
}

// Replace this function with your actual background task function
// The function must be accessible globally so that the Workmanager can call it.
void fetchBackground() async {
  // Perform your background task here
  print("Running periodic background task...");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyLoading(),
      debugShowCheckedModeBanner: false,
    );
  }
}