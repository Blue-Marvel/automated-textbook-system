import 'package:automated_texbook_system/model/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartServices {
  static final CartServices _cartServices = CartServices._internal();
  CartServices._internal();
  factory CartServices() {
    return _cartServices;
  }

  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> addBookToCart(
      {required String uid, required Cart books}) async {
    print(books.bookId);
    print(uid);
    try {
      ///[add book update] update the add book model by adding the ref change to the book and upload it to the server

      DocumentReference docRef = _firebaseFirestore
          .collection('cart')
          .doc(uid)
          .collection('books')
          .doc(books.bookId);
      Cart updatedBooks = books.copyWith(id: docRef.id);
      await docRef.set(updatedBooks.toMap());
      return docRef.id;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> removeBookFromCart(
      {required String bookId, required String uid}) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(uid)
          .collection('books')
          .doc(bookId)
          .delete();
      print('success');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Cart>> getCartBooks({required String uid}) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('cart')
          .doc(uid)
          .collection('books')
          .get();

      return snapshot.docs.map((doc) => Cart.fromMap(doc.data())).toList();
      // id: snapshot.docs.map((e) => e.id).toList()
    } catch (e) {
      rethrow;
    }
  }
}
