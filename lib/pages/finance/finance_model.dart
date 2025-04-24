class FinanceGraph {
  final DateTime reportDate;
  final int totalRevenue;
  final int totalCost;
  final int totalProfit;

  FinanceGraph({
    required this.reportDate,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
  });

   factory FinanceGraph.fromJson(Map<String, dynamic> json) {
    return FinanceGraph(
      reportDate: DateTime.parse(json['report_date']),
      totalRevenue: json['total_revenue'],
      totalCost: json['total_cost'],
      totalProfit: json['total_profit'],
    );
  }
}

class CategoryReport {
  final String categoryName;
  final int totalRevenue;
  final int totalCost;
  final int totalProfit;

  CategoryReport({
    required this.categoryName,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
  });

  factory CategoryReport.fromJson(Map<String, dynamic> json) {
    return CategoryReport(
      categoryName: json['category_name'],
      totalRevenue: json['total_revenue'],
      totalCost: json['total_cost'],
      totalProfit: json['total_profit'],
    );
  }
}
