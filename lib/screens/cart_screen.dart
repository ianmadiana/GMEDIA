import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:maspos/screens/home_screen.dart';

import '../services/cart_notifier.dart';
import '../widgets/add_button.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen(this.token, {super.key});

  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    // CART TOTAL
    final cartTotal = cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final formatter = NumberFormat('#,##0', 'id_ID');

    void goToHomeScreen() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            token: token,
          ),
        ),
        (route) => false,
      );
      ref.read(cartProvider.notifier).clearCart();
    }

    void showPopUpDialog() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Payment Successfully',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                Lottie.asset('assets/lottie/payment-success.json'),
                Text(
                  'Rp. ${formatter.format(cartTotal)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                AddButton(
                  title: 'Back to Home',
                  bgButtonColor: Colors.blue,
                  onPressed: goToHomeScreen,
                  bgTextColor: Colors.white,
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 300,
                    child: Lottie.asset('assets/lottie/empty-cart.json',
                        fit: BoxFit.fitHeight),
                  ),
                ),
                const Center(
                  child: Text('Cart is empty'),
                ),
              ],
            )
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
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .removeProductFromCart(item.id),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'PRODUCT',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'PRICE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Rp. ${formatter.format(item.price)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'QUANTITY',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => ref
                                              .read(cartProvider.notifier)
                                              .decreaseQuantity(item.id),
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text(
                                          item.quantity.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => ref
                                              .read(cartProvider.notifier)
                                              .increaseQuantity(item.id),
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'SUB TOTAL',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Rp. ${formatter.format(item.price * item.quantity)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                          'Rp. ${formatter.format(cartTotal)}',
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
                        onPressed: goToHomeScreen,
                      ),
                      const SizedBox(width: 10),
                      AddButton(
                        title: 'Pay Bill',
                        onPressed: showPopUpDialog,
                        bgButtonColor: Colors.blue,
                        bgTextColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
