import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:emart/model/Products.dart';

class ProductServices {
  // upload each images to firebase storage
  Future<String?> uploadImage(File imageFile) async {
    try {
      // path to storage
      final path = 'products/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> createProduct(Products product) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .add(product.toJson());
    } catch (e) {
      print(e);
    }
  }

  updateProduct(String? productId, Products product) {}
}

Future<void> updateProduct(productId, Products product) async {
  try {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update(product.toJson());
  } catch (e) {
    print(e);
  }
}
