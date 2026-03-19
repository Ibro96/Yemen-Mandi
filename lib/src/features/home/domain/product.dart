class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.isAvailable,
    required this.image,
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final bool isAvailable;
  final String image;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        price: (json['price'] as num).toDouble(),
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        isAvailable: json['isAvailable'] as bool? ?? true,
        image: json['image'] as String? ?? '',
      );
}
