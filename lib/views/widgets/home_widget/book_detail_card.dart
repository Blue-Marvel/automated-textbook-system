import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/model/cart.dart';
import 'package:automated_texbook_system/provider/auth_provider.dart';
import 'package:automated_texbook_system/provider/cart_provider.dart';
import 'package:automated_texbook_system/utill/colors.dart';
import 'package:automated_texbook_system/views/widgets/flash_bar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class TextBookDetailCard extends StatefulWidget {
  final TextBook textBook;
  final bool isStudent;
  const TextBookDetailCard({
    super.key,
    required this.textBook,
    this.isStudent = false,
  });

  @override
  State<TextBookDetailCard> createState() => _TextBookDetailCardState();
}

class _TextBookDetailCardState extends State<TextBookDetailCard> {
  String? bookId;
  late TextEditingController counterController;

  @override
  void initState() {
    counterController = TextEditingController(text: '1');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      height: 786,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  width: constraints.maxWidth * 0.8,
                  height: constraints.maxHeight * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: ExtendedNetworkImageProvider(
                        widget.textBook.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: constraints.maxWidth * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.textBook.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            widget.textBook.price.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const Gap(8),
                      Text(
                        widget.textBook.description,
                        softWrap: true,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(8),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Author: ',
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.textBook.author,
                              style: const TextStyle(
                                color: AppColor.textColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      const Gap(8),
                      Text.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: ' ${widget.textBook.stockNumber} ',
                            style: const TextStyle(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: 'books in stock',
                            style: TextStyle(
                              color: AppColor.textColor,
                            ),
                          )
                        ],
                      )),
                      const Gap(24),
                      //list of department using the book
                      Text(
                        'Available Departments',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.textBook.departments
                                .map(
                                  (department) => Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      department,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const Gap(20),

                      ///[if user is a student] else return edit btn
                      ///[Cart] carts btn in a row [add]  and [remove] from cart
                      ///and a box displaying the amount of books added to cart.
                      if (widget.isStudent)
                        Consumer(builder: (context, WidgetRef ref, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text('Enter Quantity: '),
                                  SizedBox(
                                    width: 70,
                                    height: 50,
                                    child: TextField(
                                      controller: counterController,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            width: 1.5,
                                            color: AppColor.textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      var bookId = widget.textBook.id;

                                      if (widget.textBook.id == '' ||
                                          counterController.text.trim() == '' ||
                                          widget.textBook.title == '') {
                                        print("error");
                                        return;
                                      }
                                      ;

                                      var cart = Cart(
                                        id: '',
                                        bookId: widget.textBook.id,
                                        bookTtile: widget.textBook.title,
                                        quantity: int.parse(
                                            counterController.text.trim()),
                                        price: widget.textBook.price,
                                      );
                                      try {
                                        await ref.read(cartProvider).addCart(
                                            books: cart,
                                            uid: ref
                                                    .read(authProvider)
                                                    .userModel
                                                    ?.id ??
                                                '');
                                      } catch (e) {
                                        FlashTopBar.flashBar(
                                            context, e.toString());
                                      }

                                      if (bookId == '') return;
                                      setState(() {
                                        this.bookId = bookId;
                                      });
                                    },
                                    child: const Text('Add'),
                                  ),
                                  const Gap(16),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Remove Book'),
                                              content: const Text(
                                                  'This will delete all copies of this book from your cart, click "Remove" to continue'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    if (bookId == null) return;

                                                    await ref
                                                        .read(cartProvider)
                                                        .removeCart(
                                                            bookId: bookId!,
                                                            uid: ref
                                                                    .read(
                                                                        authProvider)
                                                                    .userModel
                                                                    ?.id ??
                                                                '');
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Remove'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: const Text('Remove'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      if (widget.isStudent) const Gap(50),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
