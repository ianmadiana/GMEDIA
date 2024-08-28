import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maspos/models/category_model.dart';
import 'package:maspos/models/product_model.dart';
import 'package:maspos/widgets/card_item.dart';

class Category extends StatelessWidget {
  final CategoryModel category;
  final List<ProductModel> products;

  const Category({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category.name,
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CardItem(product: products[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
