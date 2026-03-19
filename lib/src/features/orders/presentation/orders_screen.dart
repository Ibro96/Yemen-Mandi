import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'orders_controller.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: orders.when(
        data: (items) => items.isEmpty
            ? const Center(child: Text('لا توجد طلبات حتى الآن'))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final o = items[i];
                  return Card(
                    child: ListTile(
                      title: Text('Order #${o.id}'),
                      subtitle: Text('${o.total} ر.س • ${o.createdAt.toLocal()}'),
                      trailing: Chip(label: Text(_label(o.status))),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('تعذر تحميل الطلبات')),
      ),
    );
  }

  String _label(String status) {
    switch (status) {
      case 'preparing':
        return 'قيد التحضير';
      case 'on_the_way':
        return 'في الطريق';
      case 'delivered':
        return 'تم التسليم';
      default:
        return status;
    }
  }
}
