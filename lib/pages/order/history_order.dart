import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';
import 'package:tadchubite/widget/textfield.dart';

class HistoryOrder extends StatelessWidget {
  final OrderController controller = Get.put(OrderController());
  final TextEditingController searchController = TextEditingController();

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              title: const Text("7 Hari Terakhir"),
              onTap: () {
                controller.fetchOrderHistories("7");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("30 Hari Terakhir"),
              onTap: () {
                controller.fetchOrderHistories("30");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Semua"),
              onTap: () {
                controller.fetchOrderHistories("");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    controller.fetchOrderHistories("");

    return Scaffold(
      backgroundColor: backgorund,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orderHistories.isEmpty) {
          return const Center(
            child: MyText(
              text: "Belum ada riwayat order",
              fontFamily: "MontserratBold",
              fontSize: 18,
              color: black,
            ),
          );
        }

        final groupedOrders = <String, List<dynamic>>{};
        for (var order in controller.orderHistories) {
          final date = (order.orderDate ?? '').split(' ')[0];
          groupedOrders.putIfAbsent(date, () => []).add(order);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyText(
                    text: "Riwayat Order",
                    fontSize: 20,
                    fontFamily: "MontserratBold",
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showFilterBottomSheet(context),
                    icon: const Icon(Icons.filter_alt, color: white),
                    label: const MyText(
                      text: "Filter Hari",
                      fontSize: 12,
                      fontFamily: "MontserratBold",
                      color: white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: groupedOrders.entries.map((entry) {
                  final date = entry.key;
                  final orders = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: MyText(
                          text: date,
                          fontFamily: "MontserratBold",
                          fontSize: 16,
                          color: darkBlue,
                        ),
                      ),
                      ...orders.map((order) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    color: yellow,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                ),
                                Padding(
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
                                          color: darkBlue,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      MyText(
                                        text:
                                            "${order.orderCode} - Rp ${order.totalPrice}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }),
);
}

}
