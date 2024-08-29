import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/cart_notifier.dart';
import '../widgets/add_button.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    final cartTotal = cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    void showPopUpDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                const Text('✅'),
                const SizedBox(height: 20),
                Text('Rp. ${cartTotal.toString()}'),
              ],
            ),
          ),
          title: const Text('Payment Successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ref.read(cartProvider.notifier).clearCart();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('PRODUCT'),
                                    Text(item.name),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('PRICE'),
                                    Text(item.price.toString()),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('QUANTITY'),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text(item.quantity.toString()),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('SUB TOTAL'),
                                    Text((item.price * item.quantity)
                                        .toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Menambahkan total cart
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CART TOTAL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          cartTotal.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AddButton(
                        title: 'Back to Home',
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      AddButton(
                        title: 'Pay Bill',
                        onPressed: showPopUpDialog,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
