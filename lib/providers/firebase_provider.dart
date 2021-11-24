import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/models/product_dao.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseProvider {

  late FirebaseFirestore _firestore;
  late CollectionReference _productsCollection;
  late FirebaseProvider _firebaseProvider;

  FirebaseProvider() {
    _firestore = FirebaseFirestore.instance;
    _productsCollection = _firestore.collection('products');
  }

  Future saveProduct(ProductDAO productDAO) {
    return _productsCollection.add(productDAO.toMap());
  }

  Future updateProduct( ProductDAO productDAO, String idProduct) {
    return _productsCollection.doc(idProduct).update(productDAO.toMap());
  }

  Future deleteProduct( String idProduct) {
    return _productsCollection.doc(idProduct).delete();
  }

  Future getProducts() {
    return _productsCollection.get();
  }

  Stream<QuerySnapshot> getAllProducts() {
    return _productsCollection.snapshots();
  }
  
  UploadTask? uploadImage(String destination, File image) {
    final ref = FirebaseStorage.instance.ref(destination);
    return ref.putFile(image);
  }
}