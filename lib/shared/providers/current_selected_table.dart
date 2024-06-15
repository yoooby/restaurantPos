import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/shared/models/table.dart';

final currentSelectedTableProvider = StateProvider<Booth?>((ref) {
  // if selected table has an order update the current order provider
  return null;
});
