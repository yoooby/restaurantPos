// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Item {
  String name;
  double price;
  String category;
  Item({
    required this.name,
    required this.price,
    required this.category,
  });

  Item copyWith({
    String? name,
    double? price,
    String? category,
  }) {
    return Item(
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'category': category,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] as String,
      price: map['price'] as double,
      category: map['category'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Item(name: $name, price: $price, category: $category)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.price == price &&
        other.category == category;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ category.hashCode;
}
