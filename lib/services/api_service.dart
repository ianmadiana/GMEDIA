import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class ApiServices {
  ApiServices(this._token);

  final String _token;
  final String baseUrl = 'https://mas-pos.appmedia.id/api/v1';

  // GET CATEGORIES
  Future<List<CategoryModel>> getCategories() async {
    String url = '$baseUrl/category';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> categoriesJson = data['data'];
        return categoriesJson
            .map((category) => CategoryModel.fromJson(category))
            .toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error $e');
      return [];
    }
  }

  // ADD CATEGORIES
  Future<void> addCategory(String categoryName) async {
    String url = '$baseUrl/category';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(
          {
            'name': categoryName,
          },
        ),
      );
      if (response.statusCode == 200) {
        print('Category added successfully');
      } else {
        print('Failed to add category');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  // ADD PRODUCT
  Future<void> addProduct(String productName, int productPrice,
      String categoryId, String picturePath) async {
    String url = 'https://mas-pos.appmedia.id/api/v1/product';

    final headers = {'Authorization': 'Bearer $_token'};

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..fields['name'] = productName
        ..fields['price'] = productPrice.toString()
        ..fields['category_id'] = categoryId;

      if (picturePath.isNotEmpty) {
        var file = await http.MultipartFile.fromPath(
          'picture_url',
          picturePath,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(file);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('$productName berhasil ditambahkan');
      } else {
        print('Failed to add product ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // GET PRODUCTS
  Future<List<ProductModel>> getAllProduct() async {
    String url = '$baseUrl/product';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> productsJson = data['data'];
        return productsJson
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error $e');
      return [];
    }
  }

// DELETE PRODUCT
  Future<void> deleteProduct(String productId) async {
    String url = '$baseUrl/product/$productId';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        print('Product $productId deleted');
      } else {
        print('Failed to delete product, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }
}
