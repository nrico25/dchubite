import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/pages/order/order_model.dart';
import 'package:tadchubite/utils/format_helper.dart';
import 'package:tadchubite/widget/button.dart';
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
        title: MyText(
          text: "Detail Pesanan",
          fontFamily: "MontserratBold",
        ),
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
            Icon(Icons.restaurant_menu, size: 120, color: darkBlue,),
            SizedBox(height: 20),
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
                  _rowInfo("Nama:", order.customerName),
                  Divider(height: 24),
                  SizedBox(height: 8),
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
                              Text(
                                  "${item.product?.name} x ${item.quantity.toStringAsFixed(0)}"),
                              Text(formatRupiah(item.price)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 8),
                  Divider(height: 24),
                  _rowInfo("Subtotal", "Rp ${formatRupiah(subtotal)}",
                      isBold: true),
                ],
              ),
            ),
            Spacer(),
            MyButton(
                text: "Selesaikan Pesanan",
                color: yellow,
                onPressed: () {
                  SubmitConfirmation(context);
                  controller.fetchPendingOrders();
                }),
          ],
        ),
      ),
    );
  }

  Widget _rowInfo(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(text: label, fontFamily: "MontserratBold"),
          MyText(
            text: value,
            fontFamily: "MontserratBold",
          ),
        ],
      ),
    );
  }
}
