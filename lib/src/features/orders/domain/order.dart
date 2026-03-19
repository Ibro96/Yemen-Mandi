class OrderModel {
  OrderModel({required this.id, required this.status, required this.total, required this.createdAt});

  final int id;
  final String status;
  final double total;
  final DateTime createdAt;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as int,
        status: json['status'] as String,
        total: (json['total'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
