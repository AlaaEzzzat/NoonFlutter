import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Package:noon/product.dart';
import 'package:noon/db.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("products"));
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 4,
        child: Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 20, end: 10, top: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: StreamBuilder<QuerySnapshot>(
              stream: db.getQueryProductsStream(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      size: 15,
                      color: Colors.red,
                    ),
                  );
                }
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final data = snapshot.requireData;
                return Container(
                    // color: Colors.white,
                    child: GridView.builder(
                        itemCount: data.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            // mainAxisSpacing: 40,
                            crossAxisCount:
                                (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? 2
                                    : 3),
                        itemBuilder: (context, index) {
                          return GridTile(
                            child: FittedBox(
                              child: Product(productData: {
                                ...data.docs[index].data(),
                                "id": data.docs[index].id
                              }, index: index),
                            ),
                          );
                        }));
              },
            ),
          ),
        ),
      )
    ]);
  }
}
