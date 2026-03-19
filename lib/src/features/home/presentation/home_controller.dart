import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/home_repository.dart';
import '../domain/product.dart';

final homeProductsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(homeRepositoryProvider).fetchProducts();
});
