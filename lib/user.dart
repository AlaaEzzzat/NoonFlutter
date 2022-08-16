import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noon/db.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  String state = "loading";
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // print('User is currently signed out!');
        setState(() {
          state = "login";
        });
      } else {
        // print('User is signed in!');
        setState(() {
          state = "account";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return state == "login"
        ? ListView(
            children: [
              //email input
              Container(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(),
                    decoration: InputDecoration(
                        labelText: "E-mail",
                        hintText: "E-mail",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.yellow, width: 2))),
                  )),
              //password input
              Container(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(),
                    decoration: InputDecoration(
                        labelText: "password",
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.yellow, width: 2))),
                  )),
              //login button
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: MaterialButton(
                  color: Colors.yellow,
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      print(userCredential.user?.uid);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "LogIn",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              //go to register button
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: MaterialButton(
                  color: Colors.yellow,
                  onPressed: () {
                    setState(() {
                      state = "register";
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Do You want to Register?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          )
        : state == "register"
            //Register Screen
            ? ListView(
                children: [
                  //name input
                  Container(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _nameController,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            labelText: "Your Name",
                            hintText: "Your Name",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.yellow, width: 2))),
                      )),
                  //email input
                  Container(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            labelText: "E-mail",
                            hintText: "E-mail",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.yellow, width: 2))),
                      )),
                  //password input
                  Container(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            labelText: "password",
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.yellow, width: 2))),
                      )),
                  //confirm password input
                  Container(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _confirmController,
                        obscureText: true,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.yellow, width: 2))),
                      )),
                  //register button
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MaterialButton(
                      color: Color.fromARGB(255, 250, 225, 1),
                      onPressed: () async {
                        RegExp emailPattern =
                            RegExp("[a-z0-9]+@[a-z]+.[a-z]{2,3}");
                        RegExp passwordPattern =
                            RegExp("^[a-zA-Z0-9!@#\$%^&*<>?|/;:`~=]{6,}\$");
                        if (!emailPattern.hasMatch(_emailController.text)) {
                          Fluttertoast.showToast(msg: "Unvalid E-mail");
                        } else if (!passwordPattern
                            .hasMatch(_passwordController.text)) {
                          Fluttertoast.showToast(
                            msg: "Password must be at least 6 chars",
                          );
                        } else if (_passwordController.text !=
                            _confirmController.text) {
                          Fluttertoast.showToast(
                              msg: "Inncorrect Confirm Password");
                        } else {
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            // print(userCredential.user?.uid);
                            //add the user to firestore
                            Map<String, dynamic> userData = {
                              "useremail": userCredential.user?.email,
                              "password": _passwordController.text,
                              "username": _nameController.text,
                              "favourites": "",
                              "orders": "",
                            };
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(userCredential.user?.uid)
                                .set(userData);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              Fluttertoast.showToast(
                                  msg: "The password provided is too weak");
                            } else if (e.code == 'email-already-in-use') {
                              Fluttertoast.showToast(
                                  msg:
                                      'The account already exists for that email.');
                            }
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  //go to register button
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MaterialButton(
                      color: Colors.yellow,
                      onPressed: () {
                        setState(() {
                          state = "login";
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Have an Account? Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : state == "account"
                ? AccountScreen()
                : Text("err");
  }
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection('users'));
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: db.getSingleDocumentStream(uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Icon(
            Icons.error,
            color: Colors.red,
            size: 15,
          ));
        }
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          child: Center(
              child: Column(
            children: [
              Text(
                'Welcome ${snapshot.data!.data()["username"]} !',
                style: TextStyle(color: Colors.yellow, fontSize: 20),
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: MaterialButton(
                    color: Colors.yellow,
                    onPressed: () async {
                      FirebaseAuth.instance.signOut().then((value) =>
                          Fluttertoast.showToast(
                              msg: "Signed Out Successfully"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Sign out",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )),
            ],
          )),
        );
      },
    );
  }
}
