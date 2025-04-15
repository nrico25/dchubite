import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/pages/order/order_model.dart';

class NotaPage extends StatelessWidget {
  final Order order;

  // Menambahkan konstruktor untuk menerima data pesanan
  NotaPage({super.key, required this.order});

  final OrderController controller = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nota"),
      ),
      body: Center(
        child: Column(
          children: [
            // Menampilkan data pesanan yang diteruskan
            Text('Customer: ${order.customerName}'),
            Text('Total Price: ${order.totalPrice}'),
            ...order.items.map(
              (item) => Text(
                'Product ID: ${item.productId}, Quantity: ${item.quantity}, Price: ${item.price}',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.completeOrder(order.id!); // Menyelesaikan pesanan yang diteruskan
              },
              child: Text('Cetak Nota / Selesaikan Order'),
            ),
          ],
        ),
      ),
    );
  }
}
