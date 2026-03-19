import '../../home/domain/product.dart';

class CartItem {
  CartItem({required this.product, this.qty = 1});
  final Product product;
  final int qty;

  CartItem copyWith({int? qty}) => CartItem(product: product, qty: qty ?? this.qty);

  double get total => qty * product.price;
}
