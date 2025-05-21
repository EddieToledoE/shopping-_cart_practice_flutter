// lib/models/product.dart
class Product {
  final int id;
  final String name;
  final String description;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'], // en la API se llama "title"
      description: json['description'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
