import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/printer_controller.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class PrinterChoice extends StatelessWidget {
  final controller = Get.find<PrinterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: MyText(
          text: "Pilih Printer",
          fontFamily: "MontserratBold",
        ),
      ),
      body: Obx(() => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: yellow.withOpacity(0.35),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.red[800],
                              size: 26,
                            ),
                            SizedBox(width: 8),
                            MyText(
                              text: "Cara Menghubungkan Printer",
                              fontFamily: "MontserratBold",
                              color: black,
                              fontSize: 16,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: "1.",
                                  fontFamily: "MontserratRegular",
                                  color: black,
                                  fontSize: 15,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: MyText(
                                    text:
                                        "Nyalakan bluetooth di perangkat Anda.",
                                    fontFamily: "MontserratRegular",
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: "2.",
                                  fontFamily: "MontserratRegular",
                                  color: black,
                                  fontSize: 15,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: MyText(
                                    text:
                                        "Pastikan printer sudah menyala dan dalam mode pairing.",
                                    fontFamily: "MontserratRegular",
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: "3.",
                                  fontFamily: "MontserratRegular",
                                  color: black,
                                  fontSize: 15,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: MyText(
                                    text:
                                        "Tekan tombol 'Cari Perangkat' lalu pilih printer yang terdeteksi.",
                                    fontFamily: "MontserratRegular",
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                  MyButton(
                    text: "Cari Perangkat",
                    onPressed: controller.scanDevices,
                    color: yellow,
                    height: 48,
                    elevation: 0,
                    borderRadius: 12,
                  ),
                SizedBox(height: 10),
                Center(
                  child: MyText(
                    text: controller.message.value,
                    fontFamily: "MontserratBold",
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: controller.devices.isEmpty
                      ? Center(
                          child: MyText(
                            text: "Tidak ada perangkat ditemukan",
                            fontFamily: "MontserratRegular",
                            color: Colors.grey,
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.devices.length,
                          itemBuilder: (context, index) {
                            final device = controller.devices[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                              child: ListTile(
                                title: MyText(
                                  text: device.name ?? "Tidak diketahui",
                                  fontFamily: "MontserratBold",
                                ),
                                subtitle: MyText(
                                  text: device.macAdress ?? "Tidak ada alamat",
                                  fontFamily: "MontserratRegular",
                                ),
                                trailing: controller.isConnected.value
                                    ? IconButton(
                                        onPressed: () =>
                                            controller.disconnectPrinter(),
                                        icon: Icon(
                                          Icons.bluetooth_connected,
                                          color: grey,
                                          size: 30,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () =>
                                            controller.connectToPrinter(
                                                device.macAdress!),
                                        icon: Icon(
                                          Icons.bluetooth,
                                          color: grey,
                                          size: 30,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                ),
                if (controller.isConnected.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: MyButton(
                      text: "Disconnect",
                      onPressed: controller.disconnectPrinter,
                      color: Colors.red,
                      height: 48,
                      elevation: 0,
                      borderRadius: 12,
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
