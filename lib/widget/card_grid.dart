import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/shimer.dart';
import 'package:tadchubite/widget/text.dart';

class OrderGridController extends GetxController {
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

class CardOrderGrid extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String price;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  CardOrderGrid({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.price,
    required this.onAdd,
    required this.onRemove,
  });

  final OrderGridController controller =
      Get.put(OrderGridController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final RxInt quantity = controller.getQuantity(imageUrl);

    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Gambar
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 40),
                );
              },
            ),
          ),

          // Konten
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: title,
                  fontSize: 16,
                  fontFamily: 'MontserratBold',
                  color: darkBlue,
                ),
                const SizedBox(height: 4),
                MyText(
                  text: category,
                  fontSize: 12,
                  fontFamily: 'MontserratRegular',
                  color: grey,
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Harga
                    MyText(
                      text: price,
                      fontSize: 14,
                      fontFamily: 'MontserratSemiBold',
                      color: yellow,
                    ),
                    const SizedBox(height: 8),
                    // Tombol Quantity
                    Obx(() {
                      return quantity.value == 0
                          ? ElevatedButton(
                              onPressed: () {
                                controller.increment(imageUrl);
                                onAdd();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
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
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.decrement(imageUrl);
                                      onRemove(); // ✅ panggil decrease di cartController
                                    },
                                    icon: Icon(Icons.remove, color: black),
                                    style: IconButton.styleFrom(
                                      backgroundColor: yellow,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
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
                                    icon: Icon(Icons.add, color: black),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
