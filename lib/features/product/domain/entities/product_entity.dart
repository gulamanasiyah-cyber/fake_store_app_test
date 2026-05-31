import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;
  final bool isFavorite;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
    this.isFavorite = false,
  });

  ProductEntity copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    double? ratingRate,
    int? ratingCount,
    bool? isFavorite,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      ratingRate: ratingRate ?? this.ratingRate,
      ratingCount: ratingCount ?? this.ratingCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        description,
        category,
        image,
        ratingRate,
        ratingCount,
        isFavorite,
      ];
}
