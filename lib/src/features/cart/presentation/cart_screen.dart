import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'cart_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final ctl = ref.read(cartProvider.notifier);
    final invalid = cart.any((e) => !e.product.isAvailable);
    final subtotal = cart.fold<double>(0, (s, e) => s + e.total);
    const delivery = 8.0;
    return Scaffold(
      appBar: AppBar(title: const Text('السلة')),
      body: cart.isEmpty
          ? const Center(child: Text('السلة فارغة'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...cart.map((item) => Card(
                      child: ListTile(
                        title: Text(item.product.name),
                        subtitle: Text('${item.total.toStringAsFixed(0)} ر.س'),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(onPressed: () => ctl.setQty(item.product.id, item.qty - 1), icon: const Icon(Icons.remove_circle_outline)),
                          Text('${item.qty}'),
                          IconButton(onPressed: () => ctl.setQty(item.product.id, item.qty + 1), icon: const Icon(Icons.add_circle_outline)),
                        ]),
                      ),
                    )),
                const SizedBox(height: 16),
                Text('Subtotal: ${subtotal.toStringAsFixed(0)} ر.س'),
                const Text('Delivery: 8 ر.س'),
                Text('Total: ${(subtotal + delivery).toStringAsFixed(0)} ر.س', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (invalid) const Padding(padding: EdgeInsets.only(top: 8), child: Text('يوجد عناصر غير متاحة حالياً', style: TextStyle(color: Colors.red))),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: cart.isNotEmpty && !invalid ? () => context.push('/checkout') : null,
          child: const Text('إكمال الطلب'),
        ),
      ),
    );
  }
}
