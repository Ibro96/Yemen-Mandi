import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/product_card.dart';
import '../../cart/presentation/cart_controller.dart';
import 'home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(homeProductsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('يمن مندي'), actions: [IconButton(onPressed: () => context.go('/cart'), icon: const Icon(Icons.shopping_cart))]),
      body: products.when(
        data: (items) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'ابحث عن وجبة', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 16),
            const Text('الأكثر طلباً', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .62, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemBuilder: (_, i) => ProductCard(
                product: items[i],
                onAdd: () => ref.read(cartProvider.notifier).add(items[i]),
                onTap: () => context.push('/product', extra: items[i]),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('تعذر تحميل المنتجات')),
      ),
    );
  }
}
