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

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchAllReports();
  }

  void fetchAllReports() async {
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
}
