import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_service.dart';
import '../domain/order.dart';

final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final raw = await ref.watch(apiServiceProvider).getOrders();
  return raw.map(OrderModel.fromJson).toList();
});
