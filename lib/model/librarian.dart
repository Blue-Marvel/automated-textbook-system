import 'dart:convert';

import 'package:flutter/widgets.dart';

class Librarian {
  final String? id;
  final String staffName;
  final String staffId;
  final String email;

  Librarian({
    this.id,
    required this.staffName,
    required this.staffId,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'staffName': staffName,
      'staffId': staffId,
      'email': email,
    };
  }

  factory Librarian.fromMap(Map<String, dynamic> map) {
    return Librarian(
      id: map['id'],
      staffName: map['staffName'] ?? '',
      staffId: map['staffId'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Librarian.fromJson(String source) =>
      Librarian.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Librarian(id: $id, staffName: $staffName, staffId: $staffId, email: $email)';
  }

  Librarian copyWith({
    ValueGetter<String?>? id,
    String? staffName,
    String? staffId,
    String? email,
  }) {
    return Librarian(
      id: id != null ? id() : this.id,
      staffName: staffName ?? this.staffName,
      staffId: staffId ?? this.staffId,
      email: email ?? this.email,
    );
  }
}
