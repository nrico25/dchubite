import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tadchubite/pages/order/detail_history.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class HistoryOrder extends StatelessWidget {
  HistoryOrder({super.key});

  final OrderController controller = Get.find<OrderController>();
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
              title: const MyText(
                text: "7 Hari Terakhir",
                fontFamily: 'MontserratRegular',
              ),
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

  String _formatTanggal(String tanggal) {
    try {
      final parsedDate = DateTime.parse(tanggal);
      return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(parsedDate);
    } catch (_) {
      return tanggal;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Auto fetch setiap kali halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderHistories("");
    });

    return Scaffold(
      backgroundColor: backgorund,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchOrderHistories("");
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // HEADER + FILTER (kembali lagi)
              SliverToBoxAdapter(
                child: Padding(
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
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (controller.orderHistories.isEmpty)
                // Placeholder kosong tapi tetap bisa di-pull
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(height: 8),
                        MyText(
                          text: "Periksa koneksi Anda",
                          fontFamily: "MontserratBold",
                          fontSize: 18,
                          color: black,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._buildGroupedOrderSlivers(),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildGroupedOrderSlivers() {
    // Group by date (YYYY-MM-DD)
    final grouped = <String, List<dynamic>>{};
    for (var order in controller.orderHistories) {
      final date = (order.orderDate ?? '').split(' ')[0];
      grouped.putIfAbsent(date, () => []).add(order);
    }

    final slivers = <Widget>[];
    grouped.forEach((date, orders) {
      // Date header
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: MyText(
              text: _formatTanggal(date),
              fontFamily: "MontserratBold",
              fontSize: 16,
              color: darkBlue,
            ),
          ),
        ),
      );

      // Orders list for that date
      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final order = orders[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () async {
                      final result =
                          await Get.to(() => DetailHistory(order: order));
                      if (result == true) {
                        controller.fetchOrderHistories("");
                      }
                    },
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
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              );
            },
            childCount: orders.length,
          ),
        ),
      );
    });

    return slivers;
    }
}
