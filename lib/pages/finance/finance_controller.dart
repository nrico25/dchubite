import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/finance/finance_model.dart';
import 'package:tadchubite/pages/finance/finance_service.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';

class ReportController extends GetxController {
  var weeklyReports = <FinanceGraph>[].obs;
  var monthlyReports = <FinanceGraph>[].obs;
  var allReports = <FinanceGraph>[].obs;

  var foodReport = Rxn<CategoryReport>();
  var drinkReport = Rxn<CategoryReport>();
  var snackReport = Rxn<CategoryReport>();
  var isLoading = false.obs;

  final reportService = ReportService();
  var categorySalesList = <CategorySalesModel>[].obs;

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchAllReports();
    loadSoldByCategory();
  }

Future<void>fetchAllReports() async {
    isLoading.value = true;
    try {
      String token = authController.token.value;

      var weekly = await ReportService.fetchWeeklyReport(token);
      weeklyReports.assignAll(weekly);

      var monthly = await ReportService.fetchMonthlyReport(token);
      weeklyReports.assignAll(monthly);

      var all = await ReportService.fetchAllReport(token);
      weeklyReports.assignAll(all);

      var food = await ReportService.fetchCategoryReport(token, 1);
      var drink = await ReportService.fetchCategoryReport(token, 2);
      var snack = await ReportService.fetchCategoryReport(token, 3);
      foodReport.value = food;
      drinkReport.value = drink;
      snackReport.value = snack;
    } catch (e) {
      Get.snackbar("Error", "$e");
    } finally {
      isLoading.value = false;
    }
  }
  Future <void> loadSoldByCategory({String? date}) async {
    try {
      String token = authController.token.value;

      isLoading.value = true;
      final today = date ?? DateTime.now().toIso8601String().split('T').first;
      final result = await reportService.fetchSoldByCategory(today, token);
      categorySalesList.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void getReportByDate(DateTime selectedDate) {
  final reportsOnSelectedDate = allReports.where((report) =>
      report.reportDate.year == selectedDate.year &&
      report.reportDate.month == selectedDate.month &&
      report.reportDate.day == selectedDate.day).toList();

  if (reportsOnSelectedDate.isEmpty) {
    Get.snackbar(
      'Tidak Ada Penjualan',
      'Tidak ditemukan data penjualan pada ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
      snackPosition: SnackPosition.BOTTOM,
    );
  } else {
    Get.defaultDialog(
      title: 'Laporan Tanggal ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reportsOnSelectedDate.map((r) =>
          Text('Pendapatan: ${r.totalRevenue}, Pengeluaran: ${r.totalCost}, Profit: ${r.totalProfit}')
        ).toList(),
      ),
    );
  }
}

}
