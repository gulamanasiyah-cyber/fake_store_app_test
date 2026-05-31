import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.ratingRate,
    required super.ratingCount,
    super.isFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final ratingMap = json['rating'] as Map<String, dynamic>? ?? {};
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num? ?? 0.0).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      ratingRate: (ratingMap['rate'] as num? ?? 0.0).toDouble(),
      ratingCount: ratingMap['count'] as int? ?? 0,
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': {
        'rate': ratingRate,
        'count': ratingCount,
      },
    };
  }
}
