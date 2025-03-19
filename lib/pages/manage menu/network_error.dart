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
            SizedBox(height: 15,),
            MyText(text: "Oops!! Sambungan anda terputus",fontFamily: "MontserratBold",fontSize: 20,),
            SizedBox(height: 3,),
            MyText(text: "Muat ulang halaman ini",fontFamily: "MontserratSemiBold",fontSize: 15,),
            
          ],
        ),
      );
  
  }
}