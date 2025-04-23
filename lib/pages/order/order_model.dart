class OrderItem {
  int productId;
  double quantity;
  double price;

  OrderItem(
      {required this.productId, required this.quantity, required this.price});

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "quantity": quantity,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      quantity: (json['quantity'] as num).toDouble(),
      price:
          json.containsKey('price') ? (json['price'] as num).toDouble() : 0.0,
    );
  }
}

class Order {
  final int? id;
  final String? orderCode;
  final String? orderDate;
  final String? status;
  final int? totalPrice;
  String customerName;
  String paymentMethod;
  int amountPaid;
  List<OrderItem> items;

  Order({
    this.id,
    this.orderDate,
    this.orderCode,
    this.status,
    this.totalPrice,
    required this.customerName,
    required this.paymentMethod,
    required this.amountPaid,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "total_price": totalPrice,
        "customer_name": customerName,
        "payment_method": paymentMethod,
        "amount_paid": amountPaid,
        "order_code": orderCode,
        "order_date": orderDate,
        "status": status,
        "items": items.map((item) => item.toJson()).toList(),
      };

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      totalPrice: json['total_price'],
      orderCode: json['order_code'],
      orderDate: json['order_date'],
      status: json['status'],
      customerName: json['customer_name'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      amountPaid: json['amount_paid'] ?? 0,
      items: (json['order_items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}