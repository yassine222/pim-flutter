import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl =
      'http://10.0.2.2:9090'; // Update with your backend URL

  static Future<List<Product>> getProducts(
      BuildContext context, String sellerId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$sellerId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      // Show a dialog if no products are found
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Products Found'),
            content: Text('No products found. Please add a product for sale before using this feature.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return []; // Return an empty list of products
    } else {
      // Handle other error cases
      throw Exception('Failed to load products');
    }
  }
}
