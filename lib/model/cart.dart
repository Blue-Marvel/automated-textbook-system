import 'dart:convert';

class Cart {
  final String? id;
  final String bookId;
  final String bookTtile;
  final int quantity;
  final double price;

  Cart({
    this.id,
    required this.bookId,
    required this.bookTtile,
    required this.quantity,
    required this.price,
  });

  Cart copyWith({
    String? id,
    String? bookId,
    String? bookTtile,
    int? quantity,
    double? price,
  }) {
    return Cart(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookTtile: bookTtile ?? this.bookTtile,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTtile': bookTtile,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] ?? '',
      bookId: map['bookId'] ?? '',
      bookTtile: map['bookTtile'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(id: $id, bookId: $bookId, bookTtile: $bookTtile, quantity: $quantity, price: $price)';
  }
}
