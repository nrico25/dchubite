import 'dart:typed_data';
import 'dart:ui' as img;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:tadchubite/pages/manage%20menu/product_model.dart';

class PrinterController extends GetxController {
  var devices = <BluetoothInfo>[].obs;
  var isConnected = false.obs;
  var message = ''.obs;

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    if (statuses.values.every((status) => status.isGranted)) {
      message.value = "Semua izin diberikan";
    } else {
      message.value = "Beberapa izin ditolak, cek pengaturan";
    }
  }

  Future<void> scanDevices() async {
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    devices.assignAll(listResult);
    message.value = listResult.isEmpty
        ? "Tidak ada perangkat Bluetooth ditemukan"
        : "Pilih printer untuk terhubung";
  }

  Future<void> connectToPrinter(String mac) async {
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    isConnected.value = result;
    message.value =
        result ? "Terhubung ke printer" : "Gagal terhubung ke printer";
  }

  Future<void> disconnectPrinter() async {
    final bool result = await PrintBluetoothThermal.disconnect;
    isConnected.value = !result;
    message.value = result ? "Koneksi terputus" : "Gagal memutuskan koneksi";
  }

  Future<void> printReceipt() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.text('TOKO SERBA ADA',
        styles: PosStyles(
            align: PosAlign.center, bold: true, height: PosTextSize.size2));
    bytes += generator.feed(1);
    bytes += generator.text('Item A       Rp 10.000');
    bytes += generator.text('Item B       Rp 5.000');
    bytes += generator.feed(1);
    bytes +=
        generator.text('TOTAL        Rp 15.000', styles: PosStyles(bold: true));
    bytes += generator.feed(2);
    bytes += generator.text('Terima kasih!',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.cut();

    final bool result = await PrintBluetoothThermal.writeBytes(bytes);
    message.value = result ? "Struk berhasil dicetak" : "Gagal mencetak struk";
  }

  Future<void> printReceiptFromOrder({
    required String customerName,
    required String paymentMethod,
    required int amountPaid,
    required Map<Product, int> cartItems,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    double total = 0;
    cartItems.forEach((product, qty) {
      total += product.price * qty;
    });
    double change = amountPaid - total;
    final ByteData data = await rootBundle.load('assets/dchubitelogo.png');
    final Uint8List imageBytes = data.buffer.asUint8List();

    // Decode gambar
    final img.Image? image = img.decodeImage(imageBytes);
    if (image != null) {
      final resizedImage = img.copyResize(image, width: 250);
      bytes += generator.image(resizedImage, align: PosAlign.center);
    }

    bytes += generator.text('Dchubite',
        styles: PosStyles(
            align: PosAlign.center, bold: true, height: PosTextSize.size2));
    bytes += generator.text(
        'Gg. 10, Kudus, Kaliputu, Kec. Kota Kudus, Kabupaten Kudus, Jawa Tengah 59312',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('No. Telp: 0895-4261-99199',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('--------------------------------',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(1);
    bytes += generator.text('Nama Customer: $customerName');
    bytes += generator.text('Pembayaran: $paymentMethod');
    bytes += generator.text('--------------------------------');
    cartItems.forEach((product, qty) {
      bytes += generator.text('${product.name} x$qty'.padRight(20) +
          'Rp ${(product.price * qty).toStringAsFixed(0)}');
    });
    bytes += generator.text('--------------------------------');
    bytes += generator.text('Total       : Rp ${total.toStringAsFixed(0)}');
    bytes +=
        generator.text('Nominal     : Rp ${amountPaid.toStringAsFixed(0)}');
    bytes += generator.text('------------------- -');
    bytes += generator.text('Kembalian   : Rp ${change.toStringAsFixed(0)}');
    bytes += generator.feed(2);
    bytes += generator.text('Terima kasih!',
        styles: PosStyles(align: PosAlign.center, height: PosTextSize.size7));
    bytes += generator.text('Silahkan datang kembali',
        styles: PosStyles(align: PosAlign.center, height: PosTextSize.size7));
    bytes += generator.cut();

    await PrintBluetoothThermal.writeBytes(bytes);
  }
}
