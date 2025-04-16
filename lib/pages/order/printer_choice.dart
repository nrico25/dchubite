import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/order/printer_controller.dart';

class PrinterChoice extends StatelessWidget {
  final controller = Get.find<PrinterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pilih Printer")),
      body: Obx(() => Column(
            children: [
              ElevatedButton(
                onPressed: controller.scanDevices,
                child: const Text("Scan Perangkat"),
              ),
              Text(controller.message.value),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];
                    return ListTile(
                      title: Text(device.name ?? "Tidak diketahui"),
                      subtitle: Text(device.macAdress ?? "Tidak ada alamat"),
                      trailing: ElevatedButton(
                        onPressed: () => controller.connectToPrinter(device.macAdress!),
                        child: const Text("Connect"),
                      ),
                    );
                  },
                ),
              ),
              if (controller.isConnected.value)
                ElevatedButton(
                  onPressed: controller.printReceipt,
                  child: const Text("Print Struk"),
                ),
              if (controller.isConnected.value)
                TextButton(
                  onPressed: controller.disconnectPrinter,
                  child: const Text("Disconnect"),
                ),
            ],
          )),
    );
  }
}
