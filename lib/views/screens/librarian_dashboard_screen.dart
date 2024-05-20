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

  @override
  void initState() {
    ref.read(uploadProvider).setBookFuture();
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
        title: Text(
          addBook ? "Add Book" : "Home",
          style: const TextStyle(
            color: Color.fromARGB(255, 17, 108, 154),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => setState(() => addBook = !addBook),
            child: Text(addBook ? 'Back Home' : 'Add Book'),
          ),
          Gap(16.w),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Profile'),
          ),
          Gap(16.w),
          ElevatedButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
          Gap(16.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder(
              future: ref.read(uploadProvider).bookFuture,
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
                : ref.watch(uploadProvider).textBookList.isNotEmpty
                    ? TextBookDetailCard(
                        textBook: ref.read(uploadProvider).textBookList[value],
                      )
                    : SizedBox(
                        height: 1.sh,
                        width: 0.4.sw,
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
