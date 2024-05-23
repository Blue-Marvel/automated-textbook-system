import 'dart:typed_data';

import 'package:automated_texbook_system/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookService {
  static final BookService _bookService = BookService._internal();
  factory BookService() {
    return _bookService;
  }
  BookService._internal();

  final _firestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  Future<void> addBook(
      {required TextBook textBook, required Uint8List file}) async {
    try {
      final uploadTask = await _firebaseStorage
          .ref()
          .child('books/${textBook.title}.png')
          .putData(file, SettableMetadata(contentType: 'image/png'));

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      final docRef = _firestore.collection('books').doc();
      final updatedTextBook =
          textBook.copyWith(imageUrl: downloadUrl, id: docRef.id);

      await docRef.set(updatedTextBook.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<TextBook>> getBooks() {
    try {
      return _firestore.collection('books').snapshots().map((snapshot) =>
          snapshot.docs.map((docs) => TextBook.fromMap(docs.data())).toList());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
