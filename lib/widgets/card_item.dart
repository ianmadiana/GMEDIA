import 'package:flutter/material.dart';
import 'package:maspos/models/product_model.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    // required this.product,
    // required this.product,
    // required this.imageUrl,
    // required this.productName,
    // required this.price,
  });

  // final String imageUrl;
  // final String productName;
  // final int price;

  // final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // Image.network(
          //   product.pictureUrl,
          //   height: 180,
          //   width: 200,
          //   fit: BoxFit.cover,
          // ),
          FlutterLogo(),
          const SizedBox(height: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Data'),
                    const SizedBox(width: 45),
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                          backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 222, 53, 11)),
                          padding:
                              WidgetStateProperty.all(const EdgeInsets.all(10)),
                          minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primary),
                  ),
                  child: const Text(
                    '+ Add to Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
