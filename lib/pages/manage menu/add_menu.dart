import 'package:flutter/material.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class AddMenu extends StatelessWidget {
  const AddMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: MyText(
          text: "Add New Menu",
          fontFamily: "MontserratBold",
          fontSize: 16,
          color: white,
        ),
        centerTitle: true,
        backgroundColor: white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
