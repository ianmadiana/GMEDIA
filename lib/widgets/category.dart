import 'package:flutter/material.dart';

import 'card_item.dart';

class Category extends StatelessWidget {
  const Category({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category 1'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // CARD ITEM
              CardItem(),
              CardItem(),
              CardItem(),
              CardItem(),
              CardItem(),
              CardItem(),
            ],
          ),
        ),
      ],
    );
  }
}
