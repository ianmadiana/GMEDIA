class ProductModel {
  final String? id;
  final String categoryId;
  final String name;
  final int price;
  final String pictureUrl;
  final String? createdAt;

  ProductModel({
    this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.pictureUrl,
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      price: json['price'],
      pictureUrl: json['picture_url'],
      createdAt: json['created_at'],
    );
  }
}
