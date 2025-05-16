import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/dashboard/controller.dart';
import 'package:tadchubite/pages/finance/finance.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/pages/manage%20menu/products.dart';
import 'package:tadchubite/pages/order/cust_queue.dart';
import 'package:tadchubite/pages/order/order.dart';
import 'package:tadchubite/pages/order/printer_page.dart';
import 'package:tadchubite/pages/setting/printer_choice.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());
    final AuthController authController =
        Get.put(AuthController());

    final List<Widget> menus = [
      FinanceReportPage(),
      OrderQueuePage(),
      ProductPage(),
      PrinterChoice(),
    ];

    final List<String> titles = [
      "Dashboard",
      "Order Queue",
      "Manage Products",
      "Settings",
    ];

    final List<IconData> icons = [
      Icons.home_filled,
      Icons.query_builder,
      Icons.inventory_2,
      Icons.settings
    ];

    return Obx(() {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(40),
            ),
            child: AppBar(
              title: MyText(
                text: titles[dashboardController.selectedIndex.value],
                fontFamily: "MontserratBold",
                fontSize: 20,
                color: white,
              ),
              centerTitle: true,
              backgroundColor: yellow,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(
                    Icons.menu_sharp,
                    color: white,
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
          child: Container(
            color: white,
            child: Column(
              children: [
                // Profile Section
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyText(
                        text: "dchubite",
                        fontSize: 16,
                        color: darkBlue,
                        fontFamily: "MontserratBold",
                      ),
                      SizedBox(height: 10),
                      MyText(
                        text: "dchubite@gmail.com",
                        fontSize: 12,
                        color: darkBlue,
                      ),
                    ],
                  ),
                ),

                // Navigation Items
                Expanded(
                  child: Column(
                    children: List.generate(titles.length, (index) {
                      bool isSelected =
                          dashboardController.selectedIndex.value == index;
                      return GestureDetector(
                        onTap: () {
                          dashboardController.changeMenu(index);
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: isSelected ? yellow : Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Row(
                            children: [
                              Icon(
                                icons[index],
                                color: isSelected ? darkBlue : black,
                              ),
                              const SizedBox(width: 10),
                              MyText(
                                text: titles[index],
                                fontSize: 14,
                                color: isSelected ? darkBlue : black,
                                fontFamily: "MontserratSemiBold",
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MyButton(
                    text: 'Log Out',
                    onPressed: () {
                      authController.logout();
                    },
                    color: darkBlue,
                    height: 40,
                    elevation: 0,
                    borderRadius: 10,
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: yellow,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     minimumSize: const Size(double.infinity, 45),
                  //   ),
                  //   onPressed: () {
                  //   },
                  //   child: MyText(
                  //     text: "Logout",
                  //     fontSize: 16,
                  //     color: white,
                  //     fontFamily: "MontserratBold",
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}