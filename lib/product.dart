import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noon/db.dart';
import 'package:noon/home.dart';
import 'package:noon/productDetails.dart';

class Products extends StatefulWidget {
  const Products(
      {Key? key,
      required this.orderByField,
      required this.count,
      required this.startWith})
      : super(key: key);
  final String orderByField;
  final int count;
  final String startWith;
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  _ProductsState();

  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.getQueryProductsStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final data = snapshot.requireData;
        return Container(
          color: Colors.white,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return Product(
                  productData: {
                    ...data.docs[index].data(),
                    "id": data.docs[index].id
                  },
                  index: index,
                );
              }),
        );
      },
    );
  }
}

class Product extends StatelessWidget {
  const Product({Key? key, required this.productData, required this.index})
      : super(key: key);
  final Map<String, dynamic> productData;
  final int index;
  @override
  Widget build(BuildContext context) {
    return //product card
        OpenContainer(
      closedColor: Colors.transparent,
      closedShape: Border(),
      closedElevation: 0,
      openElevation: 0,
      openBuilder: (context, action) => Home(),
      closedBuilder: (context, action) => Stack(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //inkwell
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                action();
              },
            ),
          ))
        ],
      ),
    );
  }
}
