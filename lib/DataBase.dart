import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  const DataBase({required this.colRef}) : super();
  final colRef;

  Stream<DocumentSnapshot> getSingleDocumentStream(String id) {
    return colRef.doc(id).snapshots();
  }

  Stream<QuerySnapshot> getQueryProductsStream(
      String orderbyField, int limitation,
      [String startat = ""]) {
    // return
    Query productsQuery = startat == ""
        ? colRef.orderBy(orderbyField, descending: true).limit(limitation)
        : colRef.orderBy(orderbyField).limit(limitation).startAt([
            startat,
          ]).endAt([
            '$startat\uf8ff',
          ]);
    return productsQuery.snapshots();
  }
}
