import 'dart:convert';

class UserModel {
  String? id;
  String name;
  String email;
  String matNo;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.matNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'matNo': matNo,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      matNo: map['matNo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? matNo,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      matNo: matNo ?? this.matNo,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, matNo: $matNo)';
  }
}
