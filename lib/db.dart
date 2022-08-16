import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  const DataBase({required this.colRef}) : super();
  final colRef;

  Stream<DocumentSnapshot> getSingleDocumentStream(String id) {
    return colRef.doc(id).snapshots();
  }

  Stream<QuerySnapshot> getQueryProductsStream() {
    // return
    Query productsQuery = colRef;
    return productsQuery.snapshots();
  }
}
