import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/session_store.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final session = ref.watch(sessionStoreProvider);
  return ApiService(session);
});

class ApiService {
  ApiService(this._session) {
    _dio = Dio(BaseOptions(baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000')));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _session.getToken();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
      ),
    );
  }

  final SessionStore _session;
  late final Dio _dio;

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final data = (response.data as List).cast<Map<String, dynamic>>();
      return data;
    } on DioException catch (_) {
      return [
        {
          'id': 1,
          'name': 'Mandi Chicken',
          'description': 'Smoked rice and chicken',
          'price': 45.0,
          'rating': 4.8,
          'isAvailable': true,
          'image': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=900'
        },
        {
          'id': 2,
          'name': 'Lamb Madfoon',
          'description': 'Premium lamb with basmati',
          'price': 68.0,
          'rating': 4.9,
          'isAvailable': false,
          'image': 'https://images.unsplash.com/photo-1604908554027-56f4b1f7f4e7?w=900'
        }
      ];
    }
  }

  Future<void> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    final token = response.data['token'] as String?;
    if (token != null) await _session.saveToken(token);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await _dio.get('/orders');
      return (response.data as List).cast<Map<String, dynamic>>();
    } on DioException {
      return [
        {'id': 1001, 'status': 'preparing', 'total': 55.0, 'createdAt': DateTime.now().toIso8601String()},
      ];
    }
  }

  Future<void> placeOrder(Map<String, dynamic> payload) async {
    await _dio.post('/orders', data: payload);
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/user/profile');
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException {
      return {'name': 'Guest User', 'phone': '+967 7XX XXX XXX', 'email': 'guest@yemenmandi.app'};
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _dio.put('/user/profile', data: data);
  }
}
