// stream tableslist provider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/common/utils.dart';
import 'package:restaurent_pos/shared/models/table.dart';
import 'package:restaurent_pos/features/tables/repository/tables_repository.dart';

final tablesControllerProvider =
    StateNotifierProvider<TablesController, bool>((ref) {
  final tablesRepository = ref.watch(tablesRepositoryProvider);
  return TablesController(ref, tablesRepository);
});
final tablesListProvider = StreamProvider.autoDispose<List<Booth>>((ref) {
  final controller = ref.watch(tablesControllerProvider.notifier);
  return controller.getTables();
});

class TablesController extends StateNotifier<bool> {
  final Ref _ref;
  final TablesRepository _tablesRepository;

  TablesController(this._ref, this._tablesRepository) : super(false);

  Future<void> addTable(BuildContext context, String name) {
    return _tablesRepository.addTable(Booth(name: name)).then((value) {
      value.fold((l) {
        showErrorSnackBar(context, l.message);
      }, (r) {
        return;
      });
    });
  }

  Stream<List<Booth>> getTables() async* {
    final tables = _tablesRepository.getTables();
    yield* tables;
  }
}
