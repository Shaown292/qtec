import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/product_model.dart';


class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    try {
      final response =
      await http.get(Uri.parse('https://dummyjson.com/products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['products'] as List)
            .map((e) => Product.fromJson(e))
            .toList();
      } else {
        throw Exception("API returned ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching products: $e");
      rethrow;
    }
  }
}