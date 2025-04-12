import 'package:get/get.dart';
import 'package:tadchubite/pages/manage%20menu/product_model.dart';
import 'package:tadchubite/pages/order/order_model.dart';

// class CartController extends GetxController {
//   var cartItems = <Product, int>{}.obs; // Simpan jumlah item per produk
//   var totalPrice = 0.0.obs;
//   var totalItems = 0.obs;

// void addToCart(Product product) {
//   if (cartItems.containsKey(product)) {
//     cartItems[product] = cartItems[product]! + 1;
//   } else {
//     cartItems[product] = 1;
//   }
//   cartItems.refresh(); // Tambahkan ini
//   totalPrice.value += product.price;
//   updateTotalItems();
// }

// void decreaseQuantity(Product product) {
//   print("Before decrease: ${cartItems[product]}");

//   if (cartItems.containsKey(product) && cartItems[product]! > 1) {
//     cartItems[product] = cartItems[product]! - 1;
//     totalPrice.value -= product.price;
//   } else {
//     removeFromCart(product);
//   }

//   cartItems.refresh();
//   updateTotalItems();

//   print("After decrease: ${cartItems[product]}");
//   print("Total items: ${totalItems.value}, Total price: ${totalPrice.value}");
// }


// void removeFromCart(Product product) {
//   if (cartItems.containsKey(product)) {
//     totalPrice.value -= product.price * cartItems[product]!;
//     cartItems.remove(product);
//   }
//   cartItems.refresh(); // Tambahkan ini
//   updateTotalItems();
// }


//   void clearCart() {
//     cartItems.clear();
//     totalPrice.value = 0.0;
//     totalItems.value = 0;
//   }

//   void updateTotalItems() {
//     totalItems.value = cartItems.values.fold(0, (sum, qty) => sum + qty);
//   }
// }



class CartController extends GetxController {
  var cartItems = <Product, int>{}.obs; // Simpan jumlah item per produk
  var totalPrice = 0.0.obs;
  var totalItems = 0.obs;

  // Tambahkan produk ke keranjang
  void addToCart(Product product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
    } else {
      cartItems[product] = 1;
    }
    cartItems.refresh();
    totalPrice.value += product.price;
    updateTotalItems();
  }

  // Kurangi kuantitas produk di keranjang
  void decreaseQuantity(Product product) {
    if (cartItems.containsKey(product) && cartItems[product]! > 1) {
      cartItems[product] = cartItems[product]! - 1;
      totalPrice.value -= product.price;
    } else {
      removeFromCart(product);
    }

    cartItems.refresh();
    updateTotalItems();
  }

  // Hapus produk dari keranjang
  void removeFromCart(Product product) {
    if (cartItems.containsKey(product)) {
      totalPrice.value -= product.price * cartItems[product]!;
      cartItems.remove(product);
    }
    cartItems.refresh();
    updateTotalItems();
  }

  // Kosongkan keranjang
  void clearCart() {
    cartItems.clear();  // hapus semua produk
    totalPrice.value = 0.0;
    totalItems.value = 0;
  }

  // Update total item di keranjang
  void updateTotalItems() {
    totalItems.value = cartItems.values.fold(0, (sum, qty) => sum + qty);
  }

  // Mengonversi cartItems menjadi OrderItem
  List<OrderItem> getOrderItems() {
    return cartItems.entries.map((entry) {
      return OrderItem(
        productId: entry.key.id,
        quantity: entry.value.toDouble(),
        price: entry.key.price,
      );
    }).toList();
  }
}


