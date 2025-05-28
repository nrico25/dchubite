import 'package:get/get.dart';
import 'package:tadchubite/pages/login/otp_service.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;

  Future<void> sendOtp(String email) async {
    try {
      isLoading.value = true;
      await ForgotPasswordService.sendOtp(email);
      Get.snackbar('Success', 'OTP has been sent to your email');
    } catch (e) {
      Get.snackbar('Error', e.toString());
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
      Get.snackbar('Success', 'Password has been reset');
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
