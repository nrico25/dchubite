import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/cust_queue.dart';
import 'package:tadchubite/pages/order/history_order.dart';
import 'package:tadchubite/pages/order/order_controller.dart';
import 'package:tadchubite/pages/order/order_model.dart';
import 'package:tadchubite/widget/color.dart';

class TabOrder extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
     return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          automaticallyImplyLeading: false,
          title: TabBar(
            indicatorColor: yellow,
            labelColor: yellow,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                text: 'Antrian',
              ),
              Tab(text: 'Riwayat Pesanan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [OrderQueuePage(), HistoryOrder()],
        ),
      ),
    );
  }
}