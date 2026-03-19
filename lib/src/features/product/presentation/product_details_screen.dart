import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/presentation/cart_controller.dart';
import '../../home/domain/product.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final Product product;

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(expandedHeight: 260, pinned: true, flexibleSpace: FlexibleSpaceBar(background: Image.network(p.image, fit: BoxFit.cover))),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(p.description),
                const SizedBox(height: 16),
                Row(children: [Chip(label: Text('⭐ ${p.rating}')), const SizedBox(width: 8), Chip(label: Text(p.isAvailable ? 'متوفر' : 'غير متوفر'))]),
                const SizedBox(height: 20),
                Row(children: [
                  IconButton(onPressed: qty > 1 ? () => setState(() => qty--) : null, icon: const Icon(Icons.remove_circle_outline)),
                  Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add_circle_outline)),
                ]),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: p.isAvailable
              ? () {
                  for (int i = 0; i < qty; i++) {
                    ref.read(cartProvider.notifier).add(p);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الإضافة للسلة')));
                }
              : null,
          child: Text('إضافة ${ (qty * p.price).toStringAsFixed(0)} ر.س'),
        ),
      ),
    );
  }
}
