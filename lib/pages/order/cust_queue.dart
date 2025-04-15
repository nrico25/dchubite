import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/nota.dart';
import 'package:tadchubite/pages/order/order.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class OrderQueuePage extends StatelessWidget {
  final OrderController controller = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgorund,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pendingOrders.isEmpty) {
          return const Center(child: Text('Tidak ada order yang pending'));
        }

        return ListView.builder(
          itemCount: controller.pendingOrders.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final order = controller.pendingOrders[index];

            return Card(
              color: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Get.to(() => NotaPage(order: order));
                },
                child: Row(
                  children: [
    
                    Container(
                      width: 40,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: lightBlue, 
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.customerName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2C4B), // Warna teks utama
                              ),
                            ),
                            const SizedBox(height: 8),
                            MyText(text: order.orderCode!),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellow,
        onPressed: () {
                   Get.toNamed('/order');
        },
        
        child: Icon(Icons.add,color: white,), 
      ),
    );
  }
}
