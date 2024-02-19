// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum Role {
  admin,
  cashier,
  waiter,
}

class User {
  final String name;
  final Role role;
  User({
    required this.name,
    required this.role,
  });

  User copyWith({
    String? name,
    Role? role,
  }) {
    return User(
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'role': role.index,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      role: Role.values[map['role'] as int],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(name: $name, role: $role)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.name == name && other.role == role;
  }

  @override
  int get hashCode => name.hashCode ^ role.hashCode;
}
