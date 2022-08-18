// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, no_logic_in_create_state, prefer_const_constructors, use_build_context_synchronously

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noon/DataBase.dart';
import 'package:noon/screens/productDetails.dart';
import 'package:shimmer/shimmer.dart';

class ProductsSnapScroll extends StatefulWidget {
  const ProductsSnapScroll(
      {Key? key,
      required this.orderByField,
      required this.count,
      required this.startWith})
      : super(key: key);
  final String orderByField;
  final int count;
  final String startWith;
  @override
  State<ProductsSnapScroll> createState() => _ProductsSnapScrollState();
}

class _ProductsSnapScrollState extends State<ProductsSnapScroll> {
  _ProductsSnapScrollState();

  DataBase db =
      DataBase(colRef: FirebaseFirestore.instance.collection("Products"));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.getQueryProductsStream(
        widget.orderByField,
        widget.count,
        widget.startWith,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {}
        if (!snapshot.hasData) {
          return FittedBox(
            child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: (Colors.grey[100])!,
                child: Container(
                    padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                    height: MediaQuery.of(context).size.width / 3,
                    child: Image(
                      image: defaultTargetPlatform == TargetPlatform.android ||
                              defaultTargetPlatform == TargetPlatform.iOS
                          ? const AssetImage("images/wideloading.png")
                          : const AssetImage("../../images/wideloading.png"),
                    ))),
          );
        }
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
      openBuilder: (context, action) =>
          ProductDetails(productID: productData['id']),
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
                        children: [
                          CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 100),
                            imageUrl: productData['thumbnail'],
                            placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: (Colors.grey[100])!,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Image(
                                      image: defaultTargetPlatform ==
                                                  TargetPlatform.android ||
                                              defaultTargetPlatform ==
                                                  TargetPlatform.iOS
                                          ? const AssetImage(
                                              "images/loading.png")
                                          : const AssetImage(
                                              "../../images/loading.png"),
                                    ))),
                          ),
                          Container(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 10, end: 10),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      productData["title"],
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    300
                                                ? 14
                                                : 10,
                                      ),
                                      maxLines: 1,
                                    ),
                                    FittedBox(
                                        child: Text(
                                      'EGP ${productData['price'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  300
                                              ? 16
                                              : 12,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                    )),
                                  ]))
                        ],
                      ),
                    ),
                  )
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
