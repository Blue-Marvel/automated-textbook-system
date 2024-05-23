import 'dart:typed_data';

import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/services/book_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadProvider =
    ChangeNotifierProvider((ref) => UploadProvider(bookService: BookService()));

class UploadProvider extends ChangeNotifier {
  final BookService _bookService;

  UploadProvider({required BookService bookService})
      : _bookService = bookService;

  final List<String> _department = [];
  final List<bool> _checkedDepartment = [];
  List<TextBook> _textBookList = [];

  List<String> get department => _department;
  List<bool> get checkedDepartment => _checkedDepartment;
  List<TextBook> get textBookList => _textBookList;

  void setDepartment(String department) {
    _department.add(department);
    notifyListeners();
  }

  void removeDepartment(String department) {
    _department.remove(department);
    notifyListeners();
  }

  Future<void> addBook(
      {required TextBook textBook, required Uint8List file}) async {
    try {
      await _bookService.addBook(textBook: textBook, file: file);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<TextBook>> getBooks() {
    try {
      // notifyListeners();

      _bookService.getBooks().listen((books) {
        _textBookList = books;
        notifyListeners();
      });
      return _bookService.getBooks();
    } catch (e) {
      rethrow;
    }
  }
}
