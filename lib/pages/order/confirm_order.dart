import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/card_order.dart'; // Pastikan sudah ada OrderController

class ConfirmOrderPage extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();
  final CartController cartController = Get.find<CartController>();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController amountPaidController = TextEditingController();
  final orderCardController = Get.find<OrderCardController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Konfirmasi Pesanan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Pesanan
            Text(
              "Ringkasan Pesanan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),

            // Menampilkan daftar produk yang dipilih
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems.keys.toList()[index];
                    final quantity = cartController.cartItems[item];
                    return ListTile(
                      title: Text(item.name), // Nama produk
                      subtitle: Text("Qty: $quantity"),
                      trailing: Text(
                          "Rp ${(item.price * quantity!).toStringAsFixed(0)}"),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 20),

            // Form untuk memasukkan nama pelanggan
            TextField(
              controller: customerNameController,
              decoration: InputDecoration(
                labelText: "Nama Pelanggan",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                orderController.customerName.value = value;
              },
            ),
            SizedBox(height: 20),

            // Form untuk memasukkan metode pembayaran
            TextField(
              controller: paymentMethodController,
              decoration: InputDecoration(
                labelText: "Metode Pembayaran",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                orderController.paymentMethod.value = value;
              },
            ),
            SizedBox(height: 20),

            // Form untuk memasukkan jumlah uang yang dibayar
            TextField(
              controller: amountPaidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Jumlah Dibayar",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                orderController.amountPaid.value = int.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 20),

            // Menampilkan total harga
            Obx(() {
              double totalPrice = 0;
              for (var entry in cartController.cartItems.entries) {
                totalPrice += entry.key.price * entry.value;
              }
              return Text(
                "Total Harga: Rp ${totalPrice.toStringAsFixed(0)}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              );
            }),
            SizedBox(height: 20),

            // Tombol untuk mengonfirmasi pesanan
            ElevatedButton(
              onPressed: () {
                orderController.submitOrder();

                // Reset data setelah konfirmasi

                if (orderController.paymentSucces.isTrue) {
                  customerNameController.text = "";
                  paymentMethodController.text = "";
                  amountPaidController.text = "";
                  orderController.resetOrderData();
                  cartController.clearCart(); // Reset keranjang
                  orderCardController.resetQuantities();
                } else {
                  print("payment kurang");
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              child: Text("Konfirmasi Pesanan",
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
