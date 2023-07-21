import 'package:cours_flutter/model/my_user.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_helper.dart';
import '../global.dart';

class UserDetails extends StatefulWidget {
  final String userId;

  String? friendName = "test";

  bool ami;

  UserDetails({
    Key? key,
    required this.userId,
    this.ami = false,
    this.friendName,
  }) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetails();
}

class _UserDetails extends State<UserDetails> {
  MyUser userDetail = MyUser.empty();
  List<MyUser> friendList = [];

  @override
  void initState() {
    FirestoreHelper().getUser(widget.userId).then((value) {
      setState(() {
        userDetail = value;
        userDetail.favoris ??= [];
        for (String index in userDetail.favoris!) {
          FirestoreHelper().getUser(index).then((value) {
            setState(() {
              friendList.add(value);
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Détails de ${widget.ami ? "l'ami de ${widget.friendName}" : "mon ami"}"),
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
        ),
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(userDetail.avatar ?? defaultImage),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Text(userDetail.fullName, style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              const Divider(height: 20, thickness: 2, color: Colors.white, indent: 50, endIndent: 50),
              const SizedBox(height: 20),
              const Text("Amis", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              ListView(
                shrinkWrap: true,
                children: [
                  for (MyUser friend in friendList)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserDetails(userId: friend.id, ami: true, friendName: userDetail.fullName)));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(friend.avatar ?? defaultImage),
                        ),
                        title: Text(friend.fullName, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(friend.email, style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                ],

              )],
          ),
        ),
      );
  }
}
