import 'product_model.dart';

class CategoryModel {
  final String id;
  final String name;
  final String createdAt;
  List<ProductModel> products; 

  CategoryModel({
    required this.id,
    required this.name,
    required this.createdAt,
    this.products = const [], 
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      products: [], 
    );
  }
}
