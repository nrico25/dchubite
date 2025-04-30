import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/pages/order/order_model.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/confirmation_message.dart';
import 'package:tadchubite/widget/text.dart';

class ConfirmPage extends StatelessWidget {
  final Order order;
  final OrderController controller = Get.find<OrderController>();

  void SubmitConfirmation(BuildContext context) async {
    final confirm = await ConfirmationMessage(
      context: context,
      title: "Selesaikan order",
      message: "Apakah Anda yakin ingin menyelesaikan order ini? ",
      cancelText: "Tidak",
      confirmText: "Ya",
      cancelColor: Colors.red,
      confirmColor: Colors.green,
    );

    if (confirm == true) {
      controller.completeOrder(order.id!);
      Get.back();
    }
  }

  ConfirmPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    int subtotal = order.totalPrice ?? 0;

    return Scaffold(
      backgroundColor: backgorund,
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Detail Pesanan",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            Icon(Icons.check, size: 120),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Rincian Nota",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rowInfo("Nama", order.customerName),
                  SizedBox(height: 8),
                  Text("Items (${order.id})",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  ...order.items.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    OrderItem item = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("x ${item.quantity.toStringAsFixed(0)}"),
                              Text("Rp ${item.price.toStringAsFixed(0)}"),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 8),
                  Divider(height: 24),
                  _rowInfo("Subtotal", "Rp $subtotal", isBold: true),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    SubmitConfirmation(context);
                    controller.fetchPendingOrders();
                  },
                  child: MyText(
                    text: "Konfirmasi pesanan",
                    fontFamily: 'MontserratBold',
                    color: white,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // Widget reusable info row
  Widget _rowInfo(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
