import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tadchubite/widget/text.dart';

class NetworkErrorPage extends StatelessWidget {
  const NetworkErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      Center(
        child: Column(
          children: [
            SizedBox(height: 150,),
            Image.asset("assets/network_error.png"),
            MyText(text: "Sambungan Anda Terputus",fontFamily: "MontserratBold",fontSize: 24,),
          ],
        ),
      );
  
  }
}