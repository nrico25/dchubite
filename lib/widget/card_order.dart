import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/shimer.dart';
import 'package:tadchubite/widget/text.dart';

class OrderCardController extends GetxController {
  var quantities = <String, RxInt>{};

  
  void resetQuantities() {
    quantities.forEach((key, value) {
      value.value = 0;  
    });
  }
  void increment(String key) {
    if (!quantities.containsKey(key)) {
      quantities[key] = 1.obs;
    } else {
      quantities[key]!.value++;
    }
  }

  void decrement(String key) {
    if (quantities.containsKey(key) && quantities[key]!.value > 0) {
      quantities[key]!.value--;
    }
  }

  RxInt getQuantity(String key) {
    return quantities.putIfAbsent(key, () => 0.obs);
  }
}

class CardOrder extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String price;
  final VoidCallback onAdd;
  final VoidCallback onRemove; // ✅ tambahan

  CardOrder({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.price,
    required this.onAdd,
    required this.onRemove, // ✅ tambahan
  });

  final OrderCardController controller = Get.put(OrderCardController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final RxInt quantity = controller.getQuantity(imageUrl);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: lightGray),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  const ShimmerWidget.rectangular(width: 80, height: 80),
                  Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 80, color: Colors.grey);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: title,
                    fontSize: 16,
                    fontFamily: 'MontserratBold',
                    color: black,
                  ),
                  MyText(
                    text: category,
                    fontSize: 14,
                    fontFamily: 'MontserratSemiBold',
                    color: grey,
                  ),
                  MyText(
                    text: price,
                    fontSize: 14,
                    fontFamily: 'MontserratRegular',
                    color: darkBlue,
                  ),
                ],
              ),
            ),
            Obx(() {
              return quantity.value == 0
                  ? ElevatedButton(
                      onPressed: () {
                        controller.increment(imageUrl);
                        onAdd();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        backgroundColor: yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: MyText(
                        text: "Tambah",
                        fontFamily: "MontserratSemiBold",
                        fontSize: 14,
                        color: white,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.decrement(imageUrl);
                              onRemove(); // ✅ panggil decrease di cartController
                            },
                            icon: Icon(Icons.remove, color: white),
                            style: IconButton.styleFrom(
                              backgroundColor: yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: MyText(
                              text: quantity.value.toString(),
                              fontSize: 16,
                              fontFamily: 'MontserratBold',
                              color: black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.increment(imageUrl);
                              onAdd();
                            },
                            icon: Icon(Icons.add, color: white),
                            style: IconButton.styleFrom(
                              backgroundColor: yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
