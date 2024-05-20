// ignore_for_file: use_build_context_synchronously

import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/provider/auth_provider.dart';
import 'package:automated_texbook_system/provider/upload_provider.dart';
import 'package:automated_texbook_system/views/screens/add_book.dart';
import 'package:automated_texbook_system/views/widgets/flash_bar.dart';
import 'package:automated_texbook_system/views/widgets/home_widget/book_detail_card.dart';
import 'package:automated_texbook_system/views/widgets/home_widget/home_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late Future<List<TextBook>> bookFuture;

  @override
  void initState() {
    bookFuture = ref.read(uploadProvider).getBooks();
    super.initState();
  }

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
            onPressed: () => setState(() => addBook = !addBook),
            child: Text(addBook ? 'Preview' : 'Add Book'),
          ),
          Gap(8.w),
          TextButton(
            onPressed: () {},
            child: const Text('Departments'),
          ),
          Gap(8.w),
          TextButton(
            onPressed: () {},
            child: const Text('Profile'),
          ),
          Gap(8.w),
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
            FutureBuilder(
              future: bookFuture,
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
                  height: 1.sh,
                  width: 0.4.sw,
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
                : FutureBuilder(
                    future: ref.read(uploadProvider).getBooks(),
                    builder: (context, snapshot) {
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
                      return TextBookDetailCard(
                        textBook: data[value],
                      );
                    }),
          ],
        ),
      ),
    );
  }
}
