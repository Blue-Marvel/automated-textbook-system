import 'dart:convert';

class Cart {
  final String? id;
  final String bookId;
  final String bookTitle;
  final int quantity;
  final double price;
  final String imageUrl;

  Cart({
    this.id,
    required this.bookId,
    required this.bookTitle,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  Cart copyWith({
    String? id,
    String? bookId,
    String? bookTtile,
    int? quantity,
    double? price,
    String? imageUrl,
  }) {
    return Cart(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTtile ?? this.bookTitle,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTtile': bookTitle,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] ?? '',
      bookId: map['bookId'] ?? '',
      bookTitle: map['bookTtile'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      price: map['price'] as double,
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(id: $id, bookId: $bookId, bookTtile: $bookTitle, quantity: $quantity, price: $price imageUrl: $imageUrl)';
  }
}
