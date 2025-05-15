import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/confirm.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';
import 'package:tadchubite/widget/textfield.dart';

class OrderQueuePage extends StatelessWidget {
  final OrderController controller = Get.find<OrderController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgorund,
      body: Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTextField(
                width: double.infinity,
                controller: searchController,
                hintText: 'Cari antrian order disini',
                keyboardType: TextInputType.text,
                borderColor: Colors.grey.shade300,
                borderWidth: 1.0,
                fillColor: Colors.white,
                textColor: Colors.black,
                hintColor: Colors.grey,
                suffixIcon: Icons.search,
                onChanged: (value) {
                  controller.searchOrders(value);
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchPendingOrders();
                },
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.pendingOrders.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 200),
                              Center(
                                  child: Text('Tidak ada order yang pending')),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.allPendingOrders.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final order = controller.allPendingOrders[index];

                              return Card(
                                color: white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () async {
                                    final result = await Get.to(
                                        () => ConfirmPage(order: order));
                                    if (result == true) {
                                      await controller.fetchPendingOrders();
                                    }
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order.customerName,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF1F2C4B),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              MyText(
                                                  text: order.orderCode ?? ""),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellow,
        onPressed: () async {
          final result = await Get.toNamed('/order'); // halaman submit
          if (result == true) {
            await controller.fetchPendingOrders();
          }
        },
        child: Icon(Icons.add, color: white),
      ),
    );
  }
}
