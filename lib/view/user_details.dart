import 'package:cours_flutter/model/my_user.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../controller/firestore_helper.dart';
import '../global.dart';

class UserDetails extends StatefulWidget {
  final String userId;

  const UserDetails({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetails();
}

class _UserDetails extends State<UserDetails> {
  MyUser userDetail = MyUser.empty();
  List<MyUser> friendList = [];
  var adresse = "";
  bool loading = true;

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
        loading = false;
      });
    });
  }

  Future<String?> getStreetFromCoordinates(double latitude, double longitude) async {
    if(latitude == null || longitude == null) return "";
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark rue = placemarks[0];
    setState(() {
      adresse = "Vu(e) pour la dernière fois à ${rue.street}, ${rue.postalCode} ${rue.locality}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de l'utilisateur"),
        bottom: PreferredSize(
            preferredSize: Size.zero,
            child: Text(adresse, style: const TextStyle(fontSize: 10, color: Colors.white))),
        backgroundColor: Colors.purple,
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
            Text(userDetail.fullName,
                style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 20),
            const Divider(
                height: 20,
                thickness: 2,
                color: Colors.white,
                indent: 50,
                endIndent: 50),
            const SizedBox(height: 20),
            const Text("Amis",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.deepOrange,
                    strokeWidth: 7,
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      if (friendList.isEmpty)
                        const Center(
                            child: Text("Cet ami n'a pas encore d'amis",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      for (MyUser friend in friendList)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserDetails(userId: friend.id)));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(friend.avatar ?? defaultImage),
                            ),
                            title: Text(friend.fullName,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(friend.email,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
