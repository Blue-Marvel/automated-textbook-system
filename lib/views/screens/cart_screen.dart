import 'package:automated_texbook_system/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key, required this.cart});
  static const String routeName = "/routename";
  final List<Cart> cart;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
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
              crossAxisCount: 1,
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
                : widget.cart.map((e) => cartListCard(e)).toList(),
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
            cart.bookTtile,
            style: const TextStyle(fontSize: 20),
          ),
          const Gap(8),
          Text("Quantity: ${cart.quantity}"),
          const Gap(8),
          Text("Price: ${cart.price}"),
        ],
      ),
    );
  }
}
