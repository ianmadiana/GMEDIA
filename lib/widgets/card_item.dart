import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:maspos/models/product_model.dart';
import 'package:maspos/services/api_service.dart';

import '../models/cart_item_model.dart';
import '../services/cart_notifier.dart';

class CardItem extends ConsumerWidget {
  const CardItem({
    super.key,
    required this.product,
    required this.token,
    required this.onLoad,
  });

  final ProductModel product;
  final String token;
  final VoidCallback onLoad;

  void _showSnackBarMessage(
      BuildContext context, String productName, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName ' '$message'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = NumberFormat('#,##0');
    final formattedPrice = formatter.format(product.price);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Image.network(
            product.pictureUrl,
            height: 130,
            width: 220,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 120,
                      child: Text(
                        product.name,
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 45),
                    TextButton(
                      onPressed: () async {
                        await ApiServices(token).deleteProduct(product.id!);

                        onLoad();

                        _showSnackBarMessage(context, product.name, 'deleted');
                      },
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
                      'Rp. $formattedPrice',
                      style: GoogleFonts.rubik(
                          fontSize: 16, fontWeight: FontWeight.w600),
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
                  onPressed: () {
                    final cartItem = CartItem(
                      id: product.id!,
                      name: product.name,
                      price: product.price,
                      quantity: 1,
                    );
                    ref.read(cartProvider.notifier).addProductToCart(cartItem);
                    _showSnackBarMessage(
                        context, product.name, 'added to cart');
                  },
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
