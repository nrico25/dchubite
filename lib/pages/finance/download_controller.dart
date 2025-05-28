import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tadchubite/pages/finance/finance_service.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';

class DownloadController extends GetxController with WidgetsBindingObserver {
  var isDownloading = false.obs;
  var isPermissionGranted = false.obs;
  final AuthController authController = Get.find<AuthController>();

  bool _snackbarShown = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    checkPermission();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(seconds: 1), () async {
        await checkPermission();
        _snackbarShown = false; // reset flag supaya snackbar bisa muncul ulang kalau perlu
      });
    }
  }

  Future<void> checkPermission() async {
    final status = await Permission.manageExternalStorage.status;
    print('DEBUG: Permission status = $status');
    if (status.isGranted) {
      if (!isPermissionGranted.value) {
        isPermissionGranted.value = true;
        if (!_snackbarShown) {
          _snackbarShown = true;
          Get.snackbar("Izin diberikan", "Anda dapat mengunduh laporan.");
        }
      }
    } else {
      isPermissionGranted.value = false;
    }
  }

  Future<void> requestPermission() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      isPermissionGranted.value = true;
      if (!_snackbarShown) {
        _snackbarShown = true;
        Get.snackbar("Izin diberikan", "Anda dapat mengunduh laporan.");
      }
    } else if (status.isPermanentlyDenied) {
      isPermissionGranted.value = false;
      if (!_snackbarShown) {
        _snackbarShown = true;
        Get.snackbar(
          "Izin ditolak",
          "Silakan aktifkan izin di pengaturan aplikasi.",
        );
      }
      openAppSettings();
    } else {
      isPermissionGranted.value = false;
      if (!_snackbarShown) {
        _snackbarShown = true;
        Get.snackbar(
          "Izin ditolak",
          "Aplikasi membutuhkan izin penyimpanan untuk mengunduh laporan.",
        );
      }
    }
  }

 Future<void> downloadMonthlyReport() async {
  try {
    isDownloading.value = true;
    String token = authController.token.value;
    final file = await ReportService.downloadMonthlyReportFile(token);
    Get.snackbar(
      "Berhasil",
      "Laporan berhasil didownload",
      mainButton: TextButton(
        onPressed: () {
          OpenFile.open(file.path);
        },
        child: Text("Buka File", style: TextStyle(color: Colors.white)),
      ),
    );
  } catch (e) {
    Get.snackbar("Gagal", "Download gagal: $e");
  } finally {
    isDownloading.value = false;
  }
}
}
