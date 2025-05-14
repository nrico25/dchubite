import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tadchubite/pages/finance/finance_controller.dart';
import 'package:tadchubite/widget/card_finance.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class FinanceReportPage extends StatelessWidget {
  final controller = Get.put(ReportController());
  final Rx<DateTimeRange?> selectedRange = Rx<DateTimeRange?>(null);
  final RxString formattedDate = ''.obs;

  FinanceReportPage({super.key}) {
    // Set default ke hari ini
    final now = DateTime.now();
    formattedDate.value = DateFormat('yyyy-MM-dd').format(now);
    controller.getCategoryReportByDate(formattedDate.value); // Fetch langsung
  }


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
            selectedRange.value = null;
            formattedDate.value = '';
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                MyText(
                  text: "Statistik Penjualan",
                  fontFamily: "MontserratBold",
                  fontSize: 20,
                  color: black,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: "Laporan per Tanggal",
                      fontFamily: "MontserratBold",
                      fontSize: 16,
                      color: black,
                    ),
                    IconButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                        );

                        if (selectedDate != null) {
                          formattedDate.value = selectedDate.toIso8601String().split('T').first;
                          controller.getCategoryReportByDate(formattedDate.value);
                        }
                      },
                      icon: Icon(Icons.calendar_today, color: yellow),
                      tooltip: "Pilih Tanggal",
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildWeeklyGraph(),
                const SizedBox(height: 16),
                Obx(() => formattedDate.value.isNotEmpty
                    ? MyText(
                        text: formattedDate.value,
                        fontFamily: "MontserratBold",
                        fontSize: 16,
                        color: black,
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 12),

                // Card Makanan
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
                            .firstWhereOrNull((e) => e.categoryId == 1)
                            ?.totalQuantitySold ??
                        0,
                    items: [],
                    reportDate: selectedRange.value?.start,
                  ),

                const SizedBox(height: 12),

                // Card Minuman
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
                            .firstWhereOrNull((e) => e.categoryId == 2)
                            ?.totalQuantitySold ??
                        0,
                    items: [],
                  ),

                const SizedBox(height: 12),

                // Card Snack
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
                            .firstWhereOrNull((e) => e.categoryId == 3)
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

  Widget _buildWeeklyGraph() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index > 6) return const SizedBox.shrink();
                  final date = _getDateForIndex(index);
                  return Text(
                    DateFormat('E').format(date),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final formatted =
                      NumberFormat.decimalPattern().format(spot.y);
                  return LineTooltipItem(
                    'Rp. $formatted',
                    TextStyle(
                      color: yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _getWeeklyData(),
              isCurved: true,
              color: yellow,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: yellow.withOpacity(0.3),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getWeeklyData() {
    final today = DateTime.now();
    final last7Days = List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      final report = controller.weeklyReports.firstWhereOrNull(
        (r) => isSameDate(r.reportDate, date),
      );
      return report?.totalProfit.toDouble() ?? 0.0;
    });

    return List.generate(
      last7Days.length,
      (index) => FlSpot(index.toDouble(), last7Days[index]),
    );
  }

  DateTime _getDateForIndex(int index) {
    final today = DateTime.now();
    return today.subtract(Duration(days: 6 - index));
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
