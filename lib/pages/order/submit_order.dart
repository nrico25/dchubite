import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/manage%20menu/product_model.dart';
import 'package:tadchubite/pages/order/cart_controller.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/pages/setting/printer_choice.dart';
import 'package:tadchubite/pages/order/printer_controller.dart';
import 'package:tadchubite/utils/format_helper.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/card_order.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/confirmation_message.dart';
import 'package:tadchubite/widget/text.dart';

class SubmitOrderPage extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();
  final CartController cartController = Get.find<CartController>();
  final PrinterController printerController = Get.find<PrinterController>();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController amountPaidController = TextEditingController();
  final orderCardController = Get.find<OrderCardController>();

  void SubmitConfirmation(BuildContext context) async {
    final confirm = await ConfirmationMessage(
      context: context,
      title: "konfirmasi pesanan",
      message: "Apakah kamu ingin mencetak nota untuk pesanan ini?  ",
      cancelText: "Tanpa Nota",
      confirmText: "Nota",
      cancelColor: Colors.grey,
      confirmColor: Colors.green,
    );

    if (confirm == true) {
      final printer = Get.find<PrinterController>();

      if (!printer.isConnected.value) {
        Get.snackbar("Printer belum terhubung",
            "Silakan hubungkan printer terlebih dahulu.");

        Get.toNamed('/setting');
        return;
      }

      bool success = await orderController.submitOrder();

      if (success && orderController.paymentSucces.isTrue) {
        await printer.printReceiptFromOrder(
          customerName: orderController.customerName.value,
          paymentMethod: orderController.paymentMethod.value,
          amountPaid: orderController.amountPaid.value,
          cartItems: Map<Product, int>.from(cartController.cartItems),
        );

        customerNameController.text = "";
        paymentMethodController.text = "cash";
        amountPaidController.text = "";
        orderController.resetOrderData();
        cartController.clearCart();
        orderCardController.resetQuantities();
        Get.toNamed('/dashboard');
        orderController.fetchPendingOrders();
      } else {
        print("payment kurang");
      }
    } else if (confirm == false) {
      bool success = await orderController.submitOrder();
      if (success && orderController.paymentSucces.isTrue) {
        customerNameController.text = "";
        paymentMethodController.text = "cash";
        amountPaidController.text = "";
        orderController.resetOrderData();
        cartController.clearCart();
        orderCardController.resetQuantities();
        Get.toNamed('/dashboard');
        orderController.fetchPendingOrders();
      } else {
        print("payment kurang");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: MyText(
        text: "Konfirmasi Pesanan",
        fontFamily: "MontserratSemiBold",
      )),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: "Ringkasan Pesanan",
              fontFamily: 'MontserratBold',
              fontSize: 20,
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
                        text: "$quantity x",
                        fontFamily: 'MontserratRegular',
                      ),
                      trailing: MyText(
                        text: "Rp ${formatRupiah(item.price * quantity!)}",
                        fontFamily: 'MontserratSemiBold',
                        fontSize: 18,
                        color: darkBlue,
                      ),
                    );
                  },
                );
              }),
            ),
            MyText(
              text:
                  '----------------------------------------------------------',
              fontSize: 16,
              fontFamily: 'MontserratRegular',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: "Total:",
                  fontFamily: 'MontserratBold',
                  fontSize: 20,
                ),
                Obx(() {
                  double totalPrice = 0;
                  for (var entry in cartController.cartItems.entries) {
                    totalPrice += entry.key.price * entry.value;
                  }
                  return MyText(
                    text: "Rp. ${formatRupiah(totalPrice)}",
                    fontFamily: 'MontserratBold',
                    fontSize: 20,
                  );
                }),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: customerNameController,
              decoration: InputDecoration(
                labelText: "Nama Pelanggan",
                labelStyle: TextStyle(fontFamily: "MontserratRegular"),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                orderController.customerName.value = value;
              },
            ),
            SizedBox(height: 20),
            Obx(() {
              return InkWell(
                onTap: () => _showPaymentMethodPicker(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Metode Pembayaran",
                    border: OutlineInputBorder(),
                  ),
                  child: MyText(
                    text: orderController.paymentMethod.value.isNotEmpty
                        ? orderController.paymentMethod.value
                        : "Pilih metode pembayaran",
                    fontFamily: 'MontserratRegular',
                  ),
                ),
              );
            }),
            SizedBox(height: 20),
            TextField(
              controller: amountPaidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Jumlah Dibayar",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                String cleanedValue = value.replaceAll(',', '');
                int? parsedValue = int.tryParse(cleanedValue);
                if (parsedValue != null) {
                  String formattedValue = formatRupiah(parsedValue);
                  amountPaidController.text = formattedValue;
                  amountPaidController.selection = TextSelection.collapsed(
                      offset: amountPaidController.text.length);
                  orderController.amountPaid.value = parsedValue;
                }
              },
            ),
            SizedBox(height: 20),
            MyButton(
              text: "Konfirmasi Pesanan",
              onPressed: () {
                SubmitConfirmation(context);
              },
              color: yellow,
              height: 56,
              elevation: 0,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}

void _showPaymentMethodPicker(BuildContext context) {
  final OrderController orderController = Get.find<OrderController>();
  final List<String> paymentMethods = ['cash', 'ewallet', 'bank_transfer'];
  String? tempSelected = orderController.paymentMethod.value;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...paymentMethods.map((method) {
                  return ListTile(
                    title: Text(
                      method,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: Radio<String>(
                      value: method,
                      groupValue: tempSelected,
                      onChanged: (value) {
                        setState(() {
                          tempSelected = value;
                        });
                      },
                    ),
                  );
                }).toList(),
                SizedBox(
                  width: double.infinity,
                  child: MyButton(
                    text: 'Pilih Metode',
                    onPressed: () {
                      if (tempSelected != null) {
                        orderController.paymentMethod.value = tempSelected!;
                      }
                      Get.back();
                    },
                    color: yellow,
                    height: 56,
                    elevation: 0,
                    borderRadius: 12,
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
