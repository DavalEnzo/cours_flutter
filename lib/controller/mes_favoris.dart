import 'package:flutter/material.dart';
import '../global.dart';
import '../model/my_user.dart';
import '../view/user_details.dart';
import 'firestore_helper.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({Key? key}) : super(key: key);

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  List<MyUser> friendList = [];
  bool loading = true;

  @override
  void initState() {
    if (me.favoris!.isEmpty) {
      setState(() {
        loading = false;
      });
    }

    for (String index in me.favoris!) {
      FirestoreHelper().getUser(index).then((value) {
        setState(() {
          friendList.add(value);
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.deepOrange,
            strokeWidth: 7,
          ),
        ),
      );
    }
    if (friendList.isEmpty) {
      return const Center(
        child: Text(
          "Vous n'avez pas encore d'amis",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: friendList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        MyUser otherUser = friendList[index];
        return InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetails(userId: otherUser.id),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(otherUser.avatar ?? defaultImage),
                ),
                const SizedBox(height: 15),
                Text(otherUser.fullName),
                Text(otherUser.email),
              ],
            ),
          ),
        );
      },
    );
  }
}
