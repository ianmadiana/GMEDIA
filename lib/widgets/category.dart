import 'package:flutter/material.dart';
import 'package:maspos/models/category_model.dart';
import 'package:maspos/models/product_model.dart';

import 'card_item.dart';

class Category extends StatelessWidget {
  const Category({
    super.key,
    // required this.categoryName,
    required this.category, required ProductModel product,
    // required this.product,
    // required this.product,
  });

  // final String categoryName;
  final CategoryModel category;
  // final ProductModel product;

  @override
  Widget build(BuildContext context) {
    print("Rendering category: ${category.name}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.name),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            CardItem(
              // product: product,
            )
          ]),
        ),
      ],
    );
  }
}
