import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/cart_item.dart';
import '../../home/domain/product.dart';

final cartProvider = StateNotifierProvider<CartController, List<CartItem>>((ref) => CartController());

class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super([]);

  void add(Product p) {
    final i = state.indexWhere((e) => e.product.id == p.id);
    if (i == -1) {
      state = [...state, CartItem(product: p)];
    } else {
      final copy = [...state];
      copy[i] = copy[i].copyWith(qty: copy[i].qty + 1);
      state = copy;
    }
  }

  void remove(int productId) {
    state = state.where((e) => e.product.id != productId).toList();
  }

  void setQty(int productId, int qty) {
    if (qty <= 0) return remove(productId);
    state = [for (final item in state) if (item.product.id == productId) item.copyWith(qty: qty) else item];
  }

  double get subtotal => state.fold(0, (sum, item) => sum + item.total);

  void clear() => state = [];
}

