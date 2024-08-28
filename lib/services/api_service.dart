import 'dart:convert';

import 'package:http/http.dart' as http;

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

  // GET ALL PRODUCT
  Future<List<ProductModel>> getAllProduct() async {
    String url = '$baseUrl/product';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        print('Response ${response.statusCode}');
      }
    } catch (e) {
      print('Errpr $e');
    }
    return [];
  }
}
