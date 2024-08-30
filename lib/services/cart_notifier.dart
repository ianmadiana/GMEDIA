import 'package:maspos/models/cart_item_model.dart';
import 'package:riverpod/riverpod.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProductToCart(CartItem item) {
    final existingItemIndex = state.indexWhere((i) => i.id == item.id);

    if (existingItemIndex != -1) {
      final existingItem = state[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );

      state = [
        ...state.sublist(0, existingItemIndex),
        updatedItem,
        ...state.sublist(existingItemIndex + 1),
      ];
    } else {
      state = [
        ...state,
        item.copyWith(quantity: 1),
      ];
    }
  }

  void decreaseQuantity(String id) {
    final existingItemIndex = state.indexWhere((i) => i.id == id);

    if (existingItemIndex != -1) {
      final existingItem = state[existingItemIndex];

      if (existingItem.quantity > 1) {
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );

        state = [
          ...state.sublist(0, existingItemIndex),
          updatedItem,
          ...state.sublist(existingItemIndex + 1),
        ];
      } else {
        removeProductFromCart(id);
      }
    }
  }

  void increaseQuantity(String id) {
    final existingItemIndex = state.indexWhere((i) => i.id == id);

    if (existingItemIndex != -1) {
      final existingItem = state[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );

      state = [
        ...state.sublist(0, existingItemIndex),
        updatedItem,
        ...state.sublist(existingItemIndex + 1),
      ];
    }
  }

  void removeProductFromCart(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
