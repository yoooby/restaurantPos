// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Booth {
  final String name;
  String? orderId;

  Booth({
    required this.name,
    this.orderId,
  });

  Booth copyWith({
    String? name,
    String? orderId,
  }) {
    return Booth(
      name: name ?? this.name,
      orderId: orderId ?? this.orderId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'orderId': orderId,
    };
  }

  factory Booth.fromMap(Map<String, dynamic> map) {
    return Booth(
      name: map['name'] as String,
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Booth.fromJson(String source) =>
      Booth.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Booth(name: $name, orderId: $orderId)';

  @override
  bool operator ==(covariant Booth other) {
    if (identical(this, other)) return true;

    return other.name == name && other.orderId == orderId;
  }

  @override
  int get hashCode => name.hashCode ^ orderId.hashCode;
}
