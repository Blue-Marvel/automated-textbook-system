import 'dart:convert';

class TextBook {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String author;
  final int stockNumber;
  final double price;
  final List<String> departments;

  TextBook({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.imageUrl,
    required this.stockNumber,
    required this.price,
    required this.departments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'imageUrl': imageUrl,
      'stockNumber': stockNumber,
      'price': price,
      'departments': departments,
    };
  }

  factory TextBook.fromMap(Map<String, dynamic> map) {
    return TextBook(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      author: map['author'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      stockNumber: map['stockNumber'] ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      departments: List<String>.from(map['departments']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TextBook.fromJson(String source) =>
      TextBook.fromMap(json.decode(source));

  TextBook copyWith({
    String? id,
    String? title,
    String? description,
    String? author,
    String? imageUrl,
    int? stockNumber,
    double? price,
    List<String>? departments,
  }) {
    return TextBook(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      stockNumber: stockNumber ?? this.stockNumber,
      price: price ?? this.price,
      departments: departments ?? this.departments,
    );
  }

  @override
  String toString() {
    return 'TextBook(id: $id, title: $title, description: $description, author: $author, imageUrl: $imageUrl, stockNumber: $stockNumber, price: $price, departments: $departments)';
  }
}
