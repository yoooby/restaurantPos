// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:restaurent_pos/models/item.dart';

class Order {
  final String id;
  final String note;
  final List<OrderItem> items;
  final bool isDone;
  final DateTime createdAt;
  final String tableId;

  Order({
    required this.id,
    required this.note,
    required this.items,
    required this.isDone,
    required this.createdAt,
    required this.tableId,
  });

  Order copyWith({
    String? id,
    String? note,
    List<OrderItem>? items,
    bool? isDone,
    DateTime? createdAt,
    String? tableId,
  }) {
    return Order(
      id: id ?? this.id,
      note: note ?? this.note,
      items: items ?? this.items,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      tableId: tableId ?? this.tableId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'note': note,
      'items': items.map((x) => x.toMap()).toList(),
      'isDone': isDone,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'tableId': tableId,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      note: map['note'] as String,
      items: List<OrderItem>.from(
        (map['items'] as List<int>).map<OrderItem>(
          (x) => OrderItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      isDone: map['isDone'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      tableId: map['tableId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, note: $note, items: $items, isDone: $isDone, createdAt: $createdAt, tableId: $tableId)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.note == note &&
        listEquals(other.items, items) &&
        other.isDone == isDone &&
        other.createdAt == createdAt &&
        other.tableId == tableId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        note.hashCode ^
        items.hashCode ^
        isDone.hashCode ^
        createdAt.hashCode ^
        tableId.hashCode;
  }
}

class OrderItem {
  final Item item;
  final int quantity;
  OrderItem({
    required this.item,
    required this.quantity,
  });

  OrderItem copyWith({
    Item? item,
    int? quantity,
  }) {
    return OrderItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item': item.toMap(),
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      item: Item.fromMap(map['item'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OrderItem(item: $item, quantity: $quantity)';

  @override
  bool operator ==(covariant OrderItem other) {
    if (identical(this, other)) return true;

    return other.item == item && other.quantity == quantity;
  }

  @override
  int get hashCode => item.hashCode ^ quantity.hashCode;
}
