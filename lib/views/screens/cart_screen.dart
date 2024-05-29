// ignore_for_file: use_build_context_synchronously

import 'package:automated_texbook_system/model/cart.dart';
import 'package:automated_texbook_system/views/screens/reciept_screen.dart';
import 'package:automated_texbook_system/views/widgets/flash_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key, required this.cart});
  static const String routeName = "/routename";
  final List<Cart> cart;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
        ),
        body: SingleChildScrollView(
          child: GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            children: widget.cart.isEmpty
                ? [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: Text("Cart is empty"),
                      ),
                    ),
                  ]
                : widget.cart
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                StatefulBuilder(builder: (context, setState) {
                              return AlertDialog(
                                title: Text(e.bookTitle),
                                content: Text("Quantity: ${e.quantity}"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      await Future.delayed(
                                          const Duration(seconds: 3));
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              PaymentReceiptScreen(cart: e),
                                        ),
                                      );
                                    },
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator())
                                        : const Text("Make payment"),
                                  ),
                                ],
                              );
                            }),
                          );
                        },
                        child: cartListCard(e),
                      ),
                    )
                    .toList(),
          ),
        ));
  }

  Widget cartListCard(Cart cart) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            cart.bookTitle,
            style: const TextStyle(fontSize: 20),
          ),
          const Gap(8),
          Text("Quantity: ${cart.quantity}"),
          const Gap(8),
          Text("Price: ${cart.price}"),
          const Gap(8),
          if (cart.imageUrl != null) Image.network(cart.imageUrl!),
        ],
      ),
    );
  }
}
