import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cours_flutter/controller/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../global.dart';
import '../model/my_user.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreHelper().cloudUsers.snapshots(),
      builder: (context, snap) {
        List documents = snap.data?.docs ?? [];
        if (documents.length == 1) {
          return const Center(
            child: Text(
              "Vous êtes le seul utilisateur",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              MyUser autreUtilisateur = MyUser(documents[index]);
              if (me.id == autreUtilisateur.id) {
                return Container();
              } else {
                return Container(
                  margin: const EdgeInsets.all(15),
                  child: Material(
                    elevation: 5,
                    color: Colors.white, // Background color for the card
                    shadowColor: Colors.grey, // Shadow color for the card
                    borderRadius: BorderRadius.circular(15),
                    child: ListTile(
                      leading: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              autreUtilisateur.avatar ?? defaultImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(autreUtilisateur.fullName),
                      subtitle: Text(autreUtilisateur.email),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: me.favoris!.contains(autreUtilisateur.id)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (me.favoris!.contains(autreUtilisateur.id)) {
                              me.favoris!.remove(autreUtilisateur.id);
                            } else {
                              me.favoris!.add(autreUtilisateur.id);
                            }
                            Map<String, dynamic> map = {
                              "favoris": me.favoris,
                            };
                            FirestoreHelper().updateUser(me.id, map);
                          });
                        },
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
