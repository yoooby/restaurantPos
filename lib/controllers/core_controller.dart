import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/common/utils.dart';
import 'package:restaurent_pos/controllers/orders.dart';
import 'package:restaurent_pos/models/item.dart';
import 'package:restaurent_pos/models/order.dart' as Model;
import 'package:restaurent_pos/models/table.dart';
import 'package:restaurent_pos/repository/core_repository.dart';
// import fpdart
import 'package:fpdart/fpdart.dart';
// import uuid
import 'package:uuid/uuid.dart';

final getOrderByIDProvider =
    FutureProvider.family<Model.Order?, String>((ref, id) async {
  final controller = ref.read(coreControllerProvider.notifier);
  return controller.getOrderByID(id);
});
final currentSelectedTableProvider = StateProvider<Booth?>((ref) {
  return null;
});

// controller provider
final coreControllerProvider =
    StateNotifierProvider<CoreController, bool>((ref) {
  final coreRepository = ref.watch(coreRepositoryProvider);
  return CoreController(ref, coreRepository);
});

// items list provider
final itemsListProvider = FutureProvider.autoDispose<List<Item>>((ref) async {
  final controller = ref.read(coreControllerProvider.notifier);
  return controller.getItems();
});

// stream tableslist provider
final tablesListProvider = StreamProvider.autoDispose<List<Booth>>((ref) {
  final controller = ref.read(coreControllerProvider.notifier);
  return controller.getTables();
});

class CoreController extends StateNotifier<bool> {
  final Ref _ref;
  final CoreRepository _coreRepository;

  CoreController(this._ref, this._coreRepository) : super(false);

  void addItem(
      BuildContext context, String name, double price, String category) {
    Item item = Item(name: name, price: price, category: category);
    _coreRepository.addItem(item).then((value) {
      value.fold((l) {
        print(l.message);
        showErrorSnackBar(context, l.message);
      }, (r) {
        return;
      });
    });
  }

  Future<List<Item>> getItems() async {
    final items = await _coreRepository.getItems();
    return items.fold((l) => [], (r) => r);
  }

  Future<void> addTable(BuildContext context, String name) {
    return _coreRepository.addTable(Booth(name: name)).then((value) {
      value.fold((l) {
        print(l.message);
        showErrorSnackBar(context, l.message);
      }, (r) {
        return;
      });
    });
  }

  Stream<List<Booth>> getTables() async* {
    final tables = _coreRepository.getTables();
    yield* tables;
  }

  Future<void> createOrder(BuildContext context, Booth table) {
    if (table.orderId != null) {
      state = false;
      showErrorSnackBar(context, 'Table Already has an order!');
    }
    state = true;
    final order = Model.Order(
      id: Uuid().v4(),
      note: '',
      items: _ref.read(currentOrderProvider),
      isDone: false,
      createdAt: DateTime.now(),
      tableId: table!.name,
    );
    return _coreRepository.createOrder(order, table).then((value) {
      value.fold((l) {
        state = false;
        showErrorSnackBar(context, l.message);
      }, (r) {
        _ref.read(currentOrderProvider.notifier).clearOrder();
        state = false;
        return;
      });
    });
  }

  // get order
  Future<Model.Order?> getOrderByID(String id) async {
    final order = await _coreRepository.getOrder(id);
    return order.fold((l) => null, (r) => r);
  }
}
