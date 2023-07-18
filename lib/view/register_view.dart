// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:cours_flutter/controller/animation_controller.dart';
import 'package:cours_flutter/controller/firestore_helper.dart';
import 'package:cours_flutter/global.dart';
import 'package:flutter/cupertino.dart';
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

  // fonction qui fait un popup d'erreur en fonction de la plateforme
  MyPopupError(dynamic erreur){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        if(Platform.isIOS){
          return CupertinoAlertDialog(
            title: const Text("Erreur de connexion"),
            content: Text("Votre email ou votre mot de passe est incorrect: $erreur"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("Erreur de connexion"),
            content: Text("Votre email ou votre mot de passe est incorrect: $erreur"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        }
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Connexion / Inscription"),
            backgroundColor: Colors.purple,
            centerTitle: true),
        body: SingleChildScrollView(
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
                      backgroundColor: Colors.purple, shape: const StadiumBorder()),
                  onPressed: () {
                    FirestoreHelper()
                        .connect(email.text, password.text)
                        .then((value) => {
                              setState(() {
                                me = value;
                              }),
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MySecondPage(
                                    password: password.text, email: email.text);
                              }))
                            })
                        .catchError((error) => {
                              MyPopupError(error)
                            });
                  },
                  child: const Text('Connexion'),
                ),
                TextButton(
                  onPressed: () {
                    FirestoreHelper().register(email.text, password.text, nom.text, prenom.text)
                        .then((value) => {
                      setState(() {
                        me = value;
                      }),
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MySecondPage(
                                password: password.text, email: email.text);
                          }))
                    })
                        .catchError((error) => {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(child: Text("Une erreur est survenue")),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          ))
                    });
                  },
                  child: const Text("inscription"),
                )
              ]),
        ))));
  }
}

class MySecondPage extends StatefulWidget {
  String password;
  String email;

  MySecondPage({
    required this.password,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  State<MySecondPage> createState() => _MySecondPageState();
}

class _MySecondPageState extends State<MySecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Connexion / Inscription"),
            backgroundColor: Colors.purple,
            centerTitle: true),
        body: Text(
            "Mon email: ${widget.email} et mon password: ${widget.password}"
        )
    );
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
