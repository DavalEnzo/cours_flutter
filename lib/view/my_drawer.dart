import 'dart:typed_data';

import 'package:cours_flutter/controller/firestore_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cours_flutter/global.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // bool pour savoir si on est en mode script ou pas
  bool isScript = false;
  TextEditingController pseudo = TextEditingController(text: me.pseudo);
  String? nameImage;
  Uint8List? bytesImages;

  // fonction
  String capitalize(String sentence) {
    if (sentence.isEmpty) {
      return sentence;
    }

    final List<String> words = sentence.split(' ');

    for (int i = 0; i < words.length; i++) {
      final String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toUpperCase() + word.substring(1);
      }
    }

    return words.join(' ');
  }

  accesPhoto() async {
    FilePickerResult? resultat = await FilePicker.platform.pickFiles(
      type: FileType.image,
        withData: true,
    );
    if(resultat != null){
      nameImage = resultat.files.first.name;
      bytesImages = resultat.files.first.bytes;
      popupImage();
    }
  }

  popupImage() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Souhaitez-vous enregistrer cette image ?"),
            content: Image.memory(bytesImages!),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Annulation", style: TextStyle(color: Colors.red))),
              TextButton(onPressed: () {
                // on enregistre l'image dans Firebase Storage
                FirestoreHelper().stockageData("images", me.id, nameImage!, bytesImages!).then((value) {
                  // on récupère l'url de l'image
                  setState(() {
                    me.avatar = value;
                  });
                  Map<String, dynamic> map = {
                    "avatar": me.avatar,
                  };
                  // on met à jour l'utilisateur dans Firebase Firestore
                  FirestoreHelper().updateUser(me.id, map);

                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Image enregistrée"))));
                }).catchError((onError){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Erreur d'enregistrement"))));
                });
                }, child: const Text("Confirmation", style: TextStyle(color: Colors.blueAccent))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // SafeArea sert à ne pas coder dans la zone où il y a les notifs ou les boutons de navigation du téléphone
    return SafeArea(
      bottom: false,
        child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    accesPhoto();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(me.avatar ?? defaultImage),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.black,
                ),
                ListTile(
                  leading: const Icon(Icons.mail, color: Colors.blueAccent),
                  title: Text(me.email, style: const TextStyle(fontSize: 20)),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueAccent),
                  title: Text(capitalize(me.fullName), style: const TextStyle(fontSize: 20)),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueAccent),
                  title: (isScript)?TextField(
                    controller: pseudo,
                    decoration: const InputDecoration(
                      labelText: "Entrez votre pseudo",
                    ),
                  ):Text(me.pseudo ?? "", style: const TextStyle(fontSize: 20)),
                  trailing: IconButton(
                    icon: Icon((isScript)?Icons.check:Icons.update),
                    onPressed: () {
                      if(isScript){
                        // On vérifie que le champ n'est pas vide
                        if(pseudo.text != "" && pseudo.text != me.pseudo){
                          // On met à jour le pseudo
                          Map<String, dynamic> map = {
                            "pseudo": pseudo.text,
                          };
                          setState(() {
                            me.pseudo = pseudo.text;
                          });
                          FirestoreHelper().updateUser(me.id, map).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Pseudo mis à jour"))));
                          }).catchError((onError){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Erreur de mise à jour"))));
                          });
                          Navigator.pop(context);
                        }
                      }
                      setState(() {
                        isScript = !isScript;
                      });
                    },
                ),
                ),
              ],
            )
        )
    );
  }
}
