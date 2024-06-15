// riverpod statenotifier<bool>

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/common/utils.dart';
import 'package:restaurent_pos/features/menu/repository/menu_repository.dart';
import 'package:restaurent_pos/shared/models/item.dart';

final coreControllerProvider =
    StateNotifierProvider<MenuController, bool>((ref) {
  final coreRepository = ref.watch(menuRepositoryProvider);
  return MenuController(ref, coreRepository);
});

final categoriesListProvider =
    FutureProvider.autoDispose<List<Map<String, int>>>((ref) async {
  final controller = ref.read(coreControllerProvider.notifier);
  return controller.getCategories();
});

final itemsListProvider = FutureProvider.autoDispose<List<Item>>((ref) async {
  final controller = ref.read(coreControllerProvider.notifier);
  return controller.getItems();
});

class MenuController extends StateNotifier<bool> {
  final Ref _ref;
  final MenuRepository _menuRepository;

  MenuController(this._ref, this._menuRepository) : super(false);

  Future<List<Item>> getItems() async {
    final items = await _menuRepository.getItems();
    return items.fold((l) => [], (r) {
      return r;
    });
  }

  // get categories list
  Future<List<Map<String, int>>> getCategories() async {
    final items = await _menuRepository.getItems();
    return items.fold((l) => [], (r) {
      final categories = r.map((e) => e.category).toSet().toList();
      final categoriesCount = categories
          .map((e) => {
                e: r.where((element) => element.category == e).length,
              })
          .toList();
      return categoriesCount;
    });
  }

  void addItem(
      BuildContext context, String name, double price, String category) {
    Item item = Item(name: name, price: price, category: category);
    _menuRepository.addItem(item).then((value) {
      value.fold((l) {
        print(l.message);
        showErrorSnackBar(context, l.message);
      }, (r) {
        return;
      });
    });
  }
}
