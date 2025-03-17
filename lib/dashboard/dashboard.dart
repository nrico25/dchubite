import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/dashboard/controller.dart';
import 'package:tadchubite/pages/manage%20menu/products.dart';
import 'package:tadchubite/pages/order/cust_queue.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());

    final List<Widget> menus = [
      CustomerQueue(),
      ProductPage(),
    ];

    final List<String> titles = [
      "Order Sek",
      "Manage Product",
    ];

    return Obx(() {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(
                  40), // Border radius hanya di pojok kanan bawah
            ),
            child: AppBar(
              title: MyText(
                text: titles[dashboardController
                    .selectedIndex.value], // Judul berubah sesuai halaman
                fontFamily: "MontserratBold",
                fontSize: 20,
                color: white,
              ),
              centerTitle: true,
              backgroundColor: yellow,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.menu_sharp,
                    color: Colors.white,
                    size: 30, 
                    weight: 800, 
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
          ),
        ),
        body: menus[dashboardController.selectedIndex.value],
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Column(
                  children: const [
                    Icon(Icons.account_circle, size: 100, color: Colors.white),
                    Text("Dchubite", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.black),
                title: const Text("Order Sek"),
                onTap: () {
                  dashboardController.changeMenu(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_rounded,
                    color: Colors.black),
                title: const Text("Manage Product"),
                onTap: () {
                  dashboardController.changeMenu(1);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
