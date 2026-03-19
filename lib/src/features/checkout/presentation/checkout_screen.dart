import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_service.dart';
import '../../cart/presentation/cart_controller.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String payment = 'cash';
  bool loading = false;

  Future<void> _placeOrder() async {
    final cart = ref.read(cartProvider);
    setState(() => loading = true);
    try {
      await ref.read(apiServiceProvider).placeOrder({
        'addressId': 1,
        'paymentMethod': payment,
        'items': [for (final i in cart) {'productId': i.product.id, 'quantity': i.qty}],
      });
      ref.read(cartProvider.notifier).clear();
      if (mounted) {
        showDialog(context: context, builder: (_) => const AlertDialog(title: Text('تم الطلب بنجاح')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل في إرسال الطلب')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('الدفع')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('العنوان'),
          const Card(child: ListTile(title: Text('المنزل - صنعاء'), subtitle: Text('شارع حدة'))),
          const SizedBox(height: 12),
          const Text('طريقة الدفع'),
          RadioListTile(value: 'cash', groupValue: payment, onChanged: (v) => setState(() => payment = v!), title: const Text('نقداً')),
          RadioListTile(value: 'card', groupValue: payment, onChanged: (v) => setState(() => payment = v!), title: const Text('بطاقة')),
          const SizedBox(height: 12),
          const Text('ملاحظات الطلب'),
          const TextField(maxLines: 3, decoration: InputDecoration(hintText: 'تعليمات التوصيل')),
          const SizedBox(height: 16),
          ...cart.map((e) => ListTile(title: Text(e.product.name), trailing: Text('${e.qty}x'))),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(onPressed: loading ? null : _placeOrder, child: Text(loading ? '...' : 'تأكيد الطلب')),
      ),
    );
  }
}
