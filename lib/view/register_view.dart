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
                      const SizedBox(height: 50),
                      Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/FoS20162016_0625_104350AA_%2827867787696%29.jpg/800px-FoS20162016_0625_104350AA_%2827867787696%29.jpg",
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: "Adresse Mail",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: nom,
                          decoration: InputDecoration(
                            labelText: "Nom",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: prenom,
                          decoration: InputDecoration(
                            labelText: "Prénom",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Mot de passe",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          shape: StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                        ),
                        onPressed: () {
                          FirestoreHelper()
                              .connect(email.text, password.text)
                              .then((value) {
                            setState(() {
                              me = value;
                            });
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const MyDashBoardView();
                              },
                            ));
                          }).catchError((error) {
                            MyPopupError(
                              error,
                              "Erreur de connexion",
                              "Votre email ou votre mot de passe est incorrect",
                              context,
                            );
                          });
                        },
                        child: const Text('Connexion'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          FirestoreHelper()
                              .register(
                            email.text,
                            password.text,
                            nom.text,
                            prenom.text,
                          )
                              .then((value) {
                            setState(() {
                              me = value;
                            });
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const MyDashBoardView();
                              },
                            ));
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Center(child: Text("Une erreur est survenue")),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        },
                        child: const Text("Inscription"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
