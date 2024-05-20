// ignore_for_file: use_build_context_synchronously

import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/provider/auth_provider.dart';
import 'package:automated_texbook_system/views/widgets/flash_bar.dart';
import 'package:automated_texbook_system/views/widgets/home_widget/book_detail_card.dart';
import 'package:automated_texbook_system/views/widgets/home_widget/home_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int value = 0;

  List<TextBook> textBooks = [
    TextBook(
      stockNumber: 34,
      id: '1',
      title: 'Python Crash Course',
      description: 'A hands-on, project-based introduction to programming.',
      author: 'Eric Matthes',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1682125776589-e899882259c3?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8dGV4dGJvb2t8ZW58MHx8MHx8fDA%3D',
      price: 39.99,
      departments: ['Computer Science', 'Software Engineering'],
    ),
    TextBook(
      stockNumber: 34,
      id: '2',
      title: 'Flutter for Beginners',
      description: 'A comprehensive guide to Flutter development.',
      author: 'John Doe',
      imageUrl:
          'https://images.unsplash.com/photo-1588912914017-923900a34710?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8dGV4dGJvb2t8ZW58MHx8MHx8fDA%3D',
      price: 29.99,
      departments: ['Mobile Development', 'Computer Science'],
    ),
    TextBook(
      stockNumber: 34,
      id: '3',
      title: 'Data Science from Scratch',
      description: 'First principles with Python.',
      author: 'Joel Grus',
      imageUrl:
          'https://images.unsplash.com/photo-1532543307581-8b01a7ff954f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8dGV4dGJvb2t8ZW58MHx8MHx8fDA%3D',
      price: 49.99,
      departments: [
        'Data Science',
        'Machine Learning',
      ],
    ),
  ];

  void logout() async {
    try {
      await ref.read(authProvider).logout();
      context.push('/');
    } catch (e) {
      FlashTopBar.flashBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
            color: Color.fromARGB(255, 17, 108, 154),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Cart (0)'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Departments'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Profile'),
          ),
          ElevatedButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            SizedBox(
              height: 1.sh,
              width: 0.4.sw,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      textBooks.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            value = index;
                          });
                        },
                        child: HomeListCard(
                          //if index = currentindex change color
                          textBook: textBooks[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextBookDetailCard(
              textBook: textBooks[value],
              isStudent: true,
            )
          ],
        ),
      ),
    );
  }
}
