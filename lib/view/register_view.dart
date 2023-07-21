// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cours_flutter/controller/animation_controller.dart';
import 'package:cours_flutter/controller/firestore_helper.dart';
import 'package:cours_flutter/global.dart';
import 'package:cours_flutter/view/dashboard_view.dart';
import 'package:cours_flutter/view/my_background.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // récupérer les champs que l'on tape dans le controller
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // title: const Text("Connexion / Inscription"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            // centerTitle: true)
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            const MyBackground(),
            SafeArea(
              child: SingleChildScrollView(
                  child: Center(
                      child: MyAnimationController(
                delay: 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                  image: NetworkImage(
                                      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/FoS20162016_0625_104350AA_%2827867787696%29.jpg/800px-FoS20162016_0625_104350AA_%2827867787696%29.jpg"),
                                  fit: BoxFit.fill))),
                      const SizedBox(height: 20),
                      const Text("Adresse Mail"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 350,
                          height: 50,
                          child: TextField(
                            controller: email,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                            ),
                          ),
                        ),
                      ),
                      const Text("Nom"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 350,
                          height: 50,
                          child: TextField(
                            controller: nom,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                            ),
                          ),
                        ),
                      ),
                      const Text("Prénom"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 350,
                          height: 50,
                          child: TextField(
                            controller: prenom,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Mot de passe"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 350,
                          height: 50,
                          child: TextField(
                            controller: password,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const StadiumBorder()),
                        onPressed: () {
                          FirestoreHelper()
                              .connect(email.text, password.text)
                              .then((value) => {
                                    setState(() {
                                      me = value;
                                    }),
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const MyDashBoardView();
                                    }))
                                  })
                              .catchError((error) => {
                                    MyPopupError(
                                        error,
                                        "Erreur de connexion",
                                        "Votre email ou votre mot de passe est incorrect",
                                        context)
                                  });
                        },
                        child: const Text('Connexion'),
                      ),
                      TextButton(
                        onPressed: () {
                          FirestoreHelper()
                              .register(
                                  email.text, password.text, nom.text, prenom.text)
                              .then((value) => {
                                    setState(() {
                                      me = value;
                                    }),
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const MyDashBoardView();
                                    }))
                                  })
                              .catchError((error) => {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Center(
                                          child: Text("Une erreur est survenue")),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ))
                                  });
                        },
                        child: const Text("inscription"),
                      )
                    ]),
              ))),
            ),
          ],
        ));
  }
}

/*Image.network("https://cdn.motor1.com/images/mgl/x2Qmp/s1/4x3/mercedes-amg-gt-r.webp")*/

/*ElevatedButton(
      	onPressed: (){
          print("j'ai appuyé");
        },
        child: const Text("Inscription")
      )
      */

/*Container(
      	height: 300,
        width: 450,
        color: Colors.red
      )
      */

/* Text("Coucou",
                 style: TextStyle(color: Colors.amberAccent, fontSize: 36))
                 */

/*TextField(
      	obscureText: true,
      )
      */
