// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/provider/auth_provider.dart';
import 'package:automated_texbook_system/provider/upload_provider.dart';
import 'package:automated_texbook_system/views/screens/add_book.dart';
import 'package:automated_texbook_system/views/widgets/flash_bar.dart';
import 'package:automated_texbook_system/views/widgets/home_widget/book_detail_card.dart';
import 'package:automated_texbook_system/views/widgets/home_widget/home_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LibrarianDashboardScreen extends ConsumerStatefulWidget {
  const LibrarianDashboardScreen({super.key});
  static const String routeName = '/librarian-dashboard';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LibrarianDashboardScreenState();
}

class _LibrarianDashboardScreenState
    extends ConsumerState<LibrarianDashboardScreen> {
  int value = 0;
  bool addBook = false;
  Stream<List<TextBook>>? getBooks;

  void logout() async {
    try {
      await ref.read(authProvider).logout();
      context.push('/');
    } catch (e) {
      FlashTopBar.flashBar(context, e.toString());
    }
  }

  @override
  void initState() {
    getBooks = ref.read(uploadProvider).getBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          addBook ? "Add Book" : "Home",
          style: const TextStyle(
            color: Color.fromARGB(255, 17, 108, 154),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => setState(() {
              addBook = !addBook;
            }),
            child: Text(addBook ? 'Back Home' : 'Add Book'),
          ),
          Gap(16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Profile'),
          ),
          Gap(16),
          ElevatedButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
          Gap(16),
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder(
              stream: getBooks,
              builder: (BuildContext context,
                  AsyncSnapshot<List<TextBook>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Text('No Textbook added yet');
                }

                final data = snapshot.data!;
                return SizedBox(
                  height: 786,
                  width: 600,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(
                          data.length,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                value = index;
                              });
                            },
                            child: HomeListCard(
                              //if index = currentindex change color
                              textBook: data[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            addBook
                ? const AddBook()
                : ref.watch(uploadProvider).textBookList.isNotEmpty
                    ? TextBookDetailCard(
                        textBook: ref.read(uploadProvider).textBookList[value],
                      )
                    : SizedBox(
                        height: 786,
                        width: 400,
                        child: const Center(
                          child: Text('No Textbook added yet'),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
