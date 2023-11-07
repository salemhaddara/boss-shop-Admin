import 'dart:core';

import 'package:bossshopadmin/config/Models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Repository {
  Future<List<Product>> fetchProducts() async {
    List<Product> products = [];
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      products = querySnapshot.docs
          .map((doc) => Product.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching products from Firestore: $e');
    }
    products.shuffle();
    return products;
  }

  Future<bool> deleteDocument(String documentId) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('products');

      final DocumentReference docRef = collection.doc(documentId);

      await docRef.delete().catchError((error) {
        print(error.toString());
      }).then((value) =>
          print('Document with ID $documentId deleted successfully.'));

      return true;
    } catch (e) {
      print('Error deleting document: $e');
      return false;
    }
  }
}
// Future<void> addProductToFirestore(Product product) async {
//   try {
//     await FirebaseFirestore.instance.collection('products').add({
//       'imagePath': product.imagePath,
//       'productName': product.productName,
//       'price': product.price,
//       'productId': product.productId,
//       'reviews': product.reviews,
//       'description': product.description,
//       'purshases': product.purshases, // Note: Corrected the typo in purchases
//       'Category': product.Category,
//     });
//     print('Product added to Firestore successfully');
//   } catch (e) {
//     print('Error adding product to Firestore: $e');
//   }
// }
