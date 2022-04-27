import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_search_api_demo/ecommerce/models/item_model.dart';
import 'package:http/http.dart' as http;


class APIClient{

  final String baseUrl = "https://panel.supplyline.network/api/product/search-suggestions/?limit=10&search=rice";
  final http.Client httpClient = http.Client();

  Future<List<ItemModel>> search(String term) async {
    final response = await httpClient.get(Uri.parse("$baseUrl"));
    final results = json.decode(response.body);

    print(results["data"]["products"]["results"]);

    if (response.statusCode == 200) {

      final items = (results["data"]["products"]["results"] as List<dynamic>)
          .map((dynamic item) =>
          ItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return items;
    } else {
      throw SearchResultError.fromJson(results);
    }
  }
}

class SearchResultError {
  const SearchResultError({@required this.message});

  final String message;

  static SearchResultError fromJson(dynamic json) {
    return SearchResultError(
      message: json['message'] as String,
    );
  }
}
