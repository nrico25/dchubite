import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tadchubite/pages/finance/finance_service.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/snackbar.dart';

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
        _snackbarShown =
            false; // reset flag supaya snackbar bisa muncul ulang kalau perlu
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
          CustomSnackbar(
            title: "Izin Diberikan",
            message: "Anda dapat mengunduh laporan.",
            backgroundColor: green,
            icon: Icons.check,
            titleStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'MontserratBold',
              color: Colors.white,
            ),
            messageStyle: TextStyle(
              fontSize: 14,
              fontFamily: 'MontserratRegular',
              color: Colors.white,
            ),
          ).show();
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
        CustomSnackbar(
          title: "Izin Diberikan",
          message: "Anda dapat mengunduh laporan.",
          backgroundColor: green,
          icon: Icons.check,
          titleStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'MontserratBold',
            color: Colors.white,
          ),
          messageStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'MontserratRegular',
            color: Colors.white,
          ),
        ).show();
      }
    } else if (status.isPermanentlyDenied) {
      isPermissionGranted.value = false;
      if (!_snackbarShown) {
        _snackbarShown = true;
        CustomSnackbar(
          title: "Izin Ditolak",
          message:
              "Anda harus memberikan izin penyimpanan untuk mengunduh laporan.",
          backgroundColor: red,
          icon: Icons.error,
          titleStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'MontserratBold',
            color: Colors.white,
          ),
          messageStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'MontserratRegular',
            color: Colors.white,
          ),
        ).show();
      }
      openAppSettings();
    } else {
      isPermissionGranted.value = false;
      if (!_snackbarShown) {
        _snackbarShown = true;
        CustomSnackbar(
          title: "Berhasil",
          message: "Laporan berhasil didownload",
          backgroundColor: green,
          icon: Icons.check,
          titleStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'MontserratBold',
            color: Colors.white,
          ),
          messageStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'MontserratRegular',
            color: Colors.white,
          ),
        ).show();
      }
    }
  }

  Future<void> downloadMonthlyReport() async {
    try {
      isDownloading.value = true;
      String token = authController.token.value;
      final file = await ReportService.downloadMonthlyReportFile(token);
      CustomSnackbar(
        title: "Berhasil",
        message: "Laporan berhasil didownload",
        backgroundColor: green,
        icon: Icons.check,
        titleStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'MontserratBold',
          color: Colors.white,
        ),
        messageStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'MontserratRegular',
          color: Colors.white,
        ),
        onPressed: () {
          OpenFile.open(file.path);
          Get.back(); // close snackbar jika diinginkan
        },
      ).show();
    } catch (e) {
           CustomSnackbar(
          title: "Download gagal",
          message:
              "Izin penyimpanan tidak diberikan. Silakan berikan izin untuk mengunduh laporan.",
          backgroundColor: red,
          icon: Icons.error,
          titleStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'MontserratBold',
            color: Colors.white,
          ),
          messageStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'MontserratRegular',
            color: Colors.white,
          ),
        ).show();
    } finally {
      isDownloading.value = false;
    }
  }
}
