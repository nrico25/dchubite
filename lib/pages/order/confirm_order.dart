import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/manage%20menu/product_model.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/pages/order/printer_choice.dart';
import 'package:tadchubite/pages/order/printer_controller.dart';
import 'package:tadchubite/widget/card_order.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart'; // Pastikan sudah ada OrderController

class ConfirmOrderPage extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();
  final CartController cartController = Get.find<CartController>();
  final PrinterController printerController = Get.find<PrinterController>();
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
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems.keys.toList()[index];
                    final quantity = cartController.cartItems[item];
                    return ListTile(
                      title: MyText(
                        text: item.name,
                        fontFamily: 'MontserratBold',
                        fontSize: 20,
                      ),
                      subtitle: MyText(
                        text: "Qty: $quantity",
                        fontFamily: 'MontserratRegular',
                      ),
                      trailing: MyText(
                        text:
                            "Rp ${(item.price * quantity!).toStringAsFixed(0)}",
                        fontFamily: 'MontserratSemiBold',
                        fontSize: 18,
                        color: lightBlue,
                      ),
                    );
                  },
                );
              }),
            ),
            MyText(
              text: '---------------------------------------- +',
              fontSize: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  double totalPrice = 0;
                  for (var entry in cartController.cartItems.entries) {
                    totalPrice += entry.key.price * entry.value;
                  }
                  return MyText(
                    text: "Total Harga: Rp ${totalPrice.toStringAsFixed(0)}",
                    fontFamily: 'MontserratRegular',
                  );
                }),
              ],
            ),
            SizedBox(height: 20),
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
            ElevatedButton(
                onPressed: () {
                  Get.to(PrinterChoice());
                },
                child: Text("Milih sek")),
            ElevatedButton(
              onPressed: () async {
                bool success = await orderController.submitOrder();
                if (orderController.paymentSucces.isTrue) {
                  final printer = Get.find<PrinterController>();

                  if (printer.isConnected.isTrue) {
                    await printer.printReceiptFromOrder(
                      customerName: orderController.customerName.value,
                      paymentMethod: orderController.paymentMethod.value,
                      amountPaid: orderController.amountPaid.value,
                      cartItems:
                          Map<Product, int>.from(cartController.cartItems),
                    );
                  } else {
                    Get.snackbar("Printer belum terhubung",
                        "Silakan hubungkan printer terlebih dahulu.");
                  }

                  customerNameController.text = "";
                  paymentMethodController.text = "";
                  amountPaidController.text = "";
                  orderController.resetOrderData();
                  cartController.clearCart();
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
