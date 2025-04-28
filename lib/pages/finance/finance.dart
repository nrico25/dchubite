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
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                MyText(
                  text: "Statistik Penjualan",
                  fontFamily: "MontserratBold",
                  fontSize: 20,
                  color: black,
                ),
                SizedBox(height: 16),
                _buildWeeklyGraph(),
                SizedBox(height: 16),
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
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('Mon');
                    case 1:
                      return Text('Tue');
                    case 2:
                      return Text('Wed');
                    case 3:
                      return Text('Thu');
                    case 4:
                      return Text('Fri');
                    case 5:
                      return Text('Sat');
                    case 6:
                      return Text('Sun');
                    default:
                      return Text('');
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
           lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final formatted = NumberFormat.decimalPattern().format(spot.y);
                return LineTooltipItem(
                  formatted,
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
    final weeklyData = controller.weeklyReports.map((report) {
      return report.totalProfit.toDouble();
    }).toList();
    return List.generate(
      weeklyData.length,
      (index) => FlSpot(index.toDouble(), weeklyData[index].toDouble()),
    );
  }
}
