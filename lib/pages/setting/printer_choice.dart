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
          title: MyText(
        text: "Pilih Printer",
        fontFamily: "MontserratBold",
      )),
      body: Obx(() => Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: MyButton(
                  text: "Cari Perangkat",
                  onPressed: controller.scanDevices,
                  color: yellow,
                  height: 56,
                  elevation: 0,
                  borderRadius: 12,
                ),
              ),
              SizedBox(height: 10),
              MyText(
                text: controller.message.value,
                fontFamily: "MontserratBold",
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];
                    return ListTile(
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
                                onPressed: () => controller
                                    .disconnectPrinter(),
                                icon: Icon(
                                  Icons.bluetooth_connected,
                                  color: grey,
                                  size: 30,
                                ),
                              )
                            : IconButton(
                                onPressed: () => controller
                                    .connectToPrinter(device.macAdress!),
                                icon: Icon(
                                  Icons.bluetooth,
                                  color: grey,
                                  size: 30,
                                ),
                              )

                        // MyButton(
                        //   onPressed: () => controller.connectToPrinter(device.macAdress!),
                        //   icon: Icons.bluetooth_connected,
                        //   text: "",
                        //   color: grey,
                        //   height: 40,
                        //   width: 75,
                        // ),
                        );
                  },
                ),
              ),
              if (controller.isConnected.value)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: MyButton(
                    text: "Disconnect",
                    onPressed: controller.disconnectPrinter,
                    color:
                        Colors.red, // atau gunakan warna lain sesuai kebutuhan
                    height: 56,
                    elevation: 0,
                    borderRadius: 12,
                  ),
                ),
            ],
          )),
    );
  }
}
