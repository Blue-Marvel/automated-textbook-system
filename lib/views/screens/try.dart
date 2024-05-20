// import 'package:automated_texbook_system/model/book.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class Try extends StatefulWidget {
//   const Try({super.key});

//   @override
//   State<Try> createState() => _TryState();
// }

// class _TryState extends State<Try> {
//   @override
//   void initState() {
//     firebase();
//     super.initState();
//   }

//   String img = '';

//   void firebase() async {
//     final firestore = FirebaseFirestore.instance;
//     final docs = await firestore.collection('books').get();
//     final books = docs.docs.map((doc) => TextBook.fromMap(doc.data())).toList();
//     setState(() {
//       img = books[2].imageUrl;
//     });
//     for (var doc in books) {
//       print(doc.imageUrl);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('image $img');
//     return SizedBox(
//       width: 200,
//       height: 200,
//       child: Image.network(img),
//     );
//   }
// }
