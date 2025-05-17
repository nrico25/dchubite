class Product {
  int id;
  int categoryId;
  String category;
  String name;
  double price;
  double costPrice;
  String image;

  Product({
    required this.id,
    required this.categoryId,
    required this.category,
    required this.name,
    required this.price,
    required this.costPrice,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0, // Jika null, ubah ke 0
      categoryId: json['category_id'] ?? 0, // Jika null, ubah ke 0
      category: json['category'] ?? '', // Pastikan tidak null
      name: json['name'] ?? '', // Pastikan tidak null
      price: double.tryParse(json['price']?.toString() ?? '0.0') ??
          0.0, // Null check
      costPrice: double.tryParse(json['cost_price']?.toString() ?? '0.0') ??
          0.0, // Null check
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "category": category,
      "name": name,
      "price": price,
      "cost_price": costPrice,
      "image": image,
    };
  }
}
