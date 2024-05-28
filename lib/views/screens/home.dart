// ignore_for_file: use_build_context_synchronously

import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/provider/auth_provider.dart';
import 'package:automated_texbook_system/provider/cart_provider.dart';
import 'package:automated_texbook_system/provider/upload_provider.dart';
import 'package:automated_texbook_system/views/screens/cart_screen.dart';
import 'package:automated_texbook_system/views/widgets/flash_bar.dart';
import 'package:automated_texbook_system/views/widgets/home_widget/book_detail_card.dart';
import 'package:automated_texbook_system/views/widgets/home_widget/home_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int value = 0;
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
    ref.read(authProvider).userModel?.id;
    getBooks = ref.read(uploadProvider).getBooks();
    getCart();
    super.initState();
  }

  getCart() async {
    if (ref.read(authProvider).userModel?.id != null) {
      await ref.read(cartProvider).setCart(
            uid: ref.read(authProvider).userModel?.id ?? '',
          );
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
            onPressed: () async {
              final cartList = await ref
                  .read(cartProvider)
                  .cartBooks(ref.read(authProvider).userModel?.id ?? '');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CartScreen(cart: cartList)));
            },
            child: Text('Cart (${ref.watch(cartProvider).cart})'),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder(
                stream: getBooks,
                builder: (context, AsyncSnapshot<List<TextBook>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Text('No Textbook added yet');
                  }

                  final textBooks = snapshot.data!;
                  return SizedBox(
                    height: 786,
                    width: 600,
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
                  );
                }),
            if (ref.watch(uploadProvider).textBookList.isNotEmpty)
              TextBookDetailCard(
                textBook: ref.watch(uploadProvider).textBookList[value],
                isStudent: true,
              ),
            if (ref.watch(uploadProvider).textBookList.isEmpty)
              const Text('No Textbook added yet'),
          ],
        ),
      ),
    );
  }
}
