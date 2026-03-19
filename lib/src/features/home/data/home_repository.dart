import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_service.dart';
import '../domain/product.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(apiServiceProvider));
});

class HomeRepository {
  HomeRepository(this.api);
  final ApiService api;

  Future<List<Product>> fetchProducts() async {
    final raw = await api.getProducts();
    return raw.map(Product.fromJson).toList();
  }
}
