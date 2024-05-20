import 'dart:html' as html;
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
      final updatedTextBook = textBook.copyWith(imageUrl: downloadUrl);

      await _firestore.collection('books').add(updatedTextBook.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TextBook>> getBooks() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      return snapshot.docs.map((doc) => TextBook.fromMap(doc.data())).toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
