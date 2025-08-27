import 'dart:typed_data';
import 'dart:ui' as img;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';
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
    bytes += generator.text('Item A       Rp ${formatCurrency(10000)}');
    bytes += generator.text('Item B       Rp ${formatCurrency(5000)}');
    bytes += generator.feed(1);
    bytes += generator.text('TOTAL        Rp ${formatCurrency(15000)}',
        styles: PosStyles(bold: true));
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

    // Decode dan resize gambar
    final img.Image? image = img.decodeImage(imageBytes);
    if (image != null) {
      final resizedImage = img.copyResize(image, width: 250);
      bytes += generator.image(resizedImage, align: PosAlign.center);
    }

    bytes += generator.text('Gg. 10 Kaliputu, Kabupaten Kudus',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('No.Telp: 0895-4261-99199',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Buka: 11.30 - 21.00 WIB',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('--------------------------------',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Nama Customer: $customerName');
    bytes += generator.text('Pembayaran: $paymentMethod');
    bytes += generator.text('--------------------------------');

    // ...existing code...
    cartItems.forEach((product, qty) {
      final subtotal = product.price * qty;
      bytes += generator.text(
        '${product.name}',
        styles: PosStyles(
            bold: true, fontType: PosFontType.fontA, height: PosTextSize.size1),
      );
      final left = '${qty} x Rp ${formatCurrency(product.price)}';
      final right = 'Rp ${formatCurrency(subtotal)}';
      bytes += generator.row([
        PosColumn(
          text: left.length > 18 ? left.substring(0, 18) : left,
          width: 6,
          styles: PosStyles(
              align: PosAlign.left,
              fontType: PosFontType.fontA,
              height: PosTextSize.size1),
        ),
        PosColumn(
          text: right,
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              fontType: PosFontType.fontA,
              height: PosTextSize.size1),
        ),
      ]);
    });
    bytes += generator.text('--------------------------------');

// Sub Total
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
            bold: true),
      ),
      PosColumn(
        text: 'Rp ${formatCurrency(total)}',
        width: 6,
        styles: PosStyles(
            align: PosAlign.right,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1,
            bold: true),
      ),
    ]);
    bytes += generator.text('--------------------------------');

// Tunai
    bytes += generator.row([
      PosColumn(
        text: 'Tunai',
        width: 6,
        styles: PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1),
      ),
      PosColumn(
        text: 'Rp ${formatCurrency(amountPaid)}',
        width: 6,
        styles: PosStyles(
            align: PosAlign.right,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1),
      ),
    ]);

// Kembalian
    bytes += generator.row([
      PosColumn(
        text: 'Kembalian',
        width: 6,
        styles: PosStyles(
            align: PosAlign.left,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1),
      ),
      PosColumn(
        text: 'Rp ${formatCurrency(change)}',
        width: 6,
        styles: PosStyles(
            align: PosAlign.right,
            fontType: PosFontType.fontA,
            height: PosTextSize.size1),
      ),
    ]);
    bytes += generator.feed(2);
    bytes += generator.text('Terima kasih!',
        styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2));
    final String now = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    bytes += generator.text('$now',
        styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1));
    bytes += generator.feed(2);
// ...existing code...

    await PrintBluetoothThermal.writeBytes(bytes);
  }

  String formatCurrency(num number) {
    return number.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );
  }
}
