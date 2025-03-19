import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tadchubite/widget/text.dart';

class EmptyProductPage extends StatelessWidget {
  const EmptyProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      Center(
        child: Column(
          children: [
            SizedBox(height: 150,),
            Image.asset("assets/empty_product.png"),
            SizedBox(height: 15,),
            MyText(text: "Belum ada Product saat ini",fontFamily: "MontserratBold",fontSize: 20,),
          ],
        ),
      );
  
  }
}