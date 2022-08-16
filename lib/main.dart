import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noon/db.dart';
import 'package:noon/products.dart';
import 'package:noon/home.dart';
import 'package:noon/user.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCFciE7URwMXLW9Z_eZ0rAhANyHpAOwJ3E",
            appId: "1:884703040907:web:5f4f64f2de4b1f44ba4b8e",
            messagingSenderId: "884703040907",
            projectId: "noon-3e078"));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noon',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(
        title: 'Noon Home Page',
        firstLoad: true,
        btmSelectedIndex: 0,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.title,
      required this.firstLoad,
      required this.btmSelectedIndex})
      : super(key: key);
  final bool firstLoad;
  final int btmSelectedIndex;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Key key = UniqueKey();
  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  bool insplashScreen = true;
  int btmSelectedIndex = 0;
  List screens = [Home(), Products(), UserPage(), Home(), Home()];

  @override
  void initState() {
    super.initState();
    setState(() {
      btmSelectedIndex = widget.btmSelectedIndex;
    });
    navigateToHome();
  }

  navigateToHome() async {
    if (widget.firstLoad) {
      await Future.delayed(Duration(seconds: 3), () {});
      setState(() {
        insplashScreen = false;
      });
    } else {
      setState(() {
        insplashScreen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(245, 245, 245, 1),
          body: screens[btmSelectedIndex],
          // Bottom Bar
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: btmSelectedIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_list_bulleted_outlined),
                  label: "Products"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_checkout), label: "Cart"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: "Login"),
            ],
            elevation: 2,
            selectedItemColor: Colors.yellow,
            unselectedItemColor: Color.fromARGB(255, 90, 88, 88),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedFontSize: 12,
            selectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              setState(() {
                btmSelectedIndex = index;
              });
            },
          ),
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              "Noon",
              style: TextStyle(color: Colors.white),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () async {
                setState(() {
                  // Restart.restartApp();
                  key = UniqueKey();
                });
              }),
        ));
  }
}
