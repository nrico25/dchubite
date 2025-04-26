import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tadchubite/pages/finance/finance_controller.dart';
import 'package:tadchubite/widget/card_finance.dart';
import 'package:tadchubite/widget/color.dart';

class FinanceReportPage extends StatelessWidget {
  final controller = Get.put(ReportController());

  FinanceReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgorund,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchAllReports();
            await controller.loadSoldByCategory();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                if (controller.foodReport.value != null)
                  CardFinance(
                    title: "Makanan",
                    penjualanKotor:
                        controller.foodReport.value!.totalRevenue.toDouble(),
                    modalAwal:
                        controller.foodReport.value!.totalCost.toDouble(),
                    penjualanBersih:
                        controller.foodReport.value!.totalProfit.toDouble(),
                    produkTerjual: controller.categorySalesList
                            .firstWhereOrNull(
                              (e) => e.categoryId == 1,
                            )
                            ?.totalQuantitySold ??
                        0,
                    items: [],
                  ),
                const SizedBox(height: 16),
                if (controller.drinkReport.value != null)
                  CardFinance(
                    title: "Minuman",
                    penjualanKotor:
                        controller.drinkReport.value!.totalRevenue.toDouble(),
                    modalAwal:
                        controller.drinkReport.value!.totalCost.toDouble(),
                    penjualanBersih:
                        controller.drinkReport.value!.totalProfit.toDouble(),
                    produkTerjual: controller.categorySalesList
                            .firstWhereOrNull(
                              (e) => e.categoryId == 2,
                            )
                            ?.totalQuantitySold ??
                        0,
                    items: [],
                  ),
                const SizedBox(height: 16),
                if (controller.snackReport.value != null)
                  CardFinance(
                    title: "Snack",
                    penjualanKotor:
                        controller.snackReport.value!.totalRevenue.toDouble(),
                    modalAwal:
                        controller.snackReport.value!.totalCost.toDouble(),
                    penjualanBersih:
                        controller.snackReport.value!.totalProfit.toDouble(),
                    produkTerjual: controller.categorySalesList
                            .firstWhereOrNull(
                              (e) => e.categoryId == 3,
                            )
                            ?.totalQuantitySold ??
                        0,
                    items: [],
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
