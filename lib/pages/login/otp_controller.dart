import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/otp_service.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/snackbar.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;

  Future<void> sendOtp(String email) async {
    try {
      isLoading.value = true;
      await ForgotPasswordService.sendOtp(email);
       CustomSnackbar(
        title: "success",
        message: "otp telah dikirim ke email anda",
        backgroundColor: green,
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
    } catch (e) {
       CustomSnackbar(
        title: "error",
        message: "Kode otp gagal dikirim",
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
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(
      String email, String otp, String password, String confirmPassword) async {
    try {
      isLoading.value = true;
      await ForgotPasswordService.resetPassword(
          email, otp, password, confirmPassword);
      CustomSnackbar(
        title: "Success",
        message: "Password telah diganti",
        backgroundColor: green,
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
      Get.offAllNamed('/login');
    } catch (e) {
   CustomSnackbar(
        title: "Error",
        message: "Pastikan semua kolom terisi",
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
      isLoading.value = false;
    }
  }
}
