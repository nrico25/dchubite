import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/otp_controller.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';

class ResetPasswordPage extends StatelessWidget {
  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color:grey),
        child: Center(
          child: SingleChildScrollView(
            padding:  EdgeInsets.symmetric(horizontal: 30),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding:  EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Icon(Icons.lock_reset_rounded,
                        size: 80, color: black),
                     SizedBox(height: 20),
                    MyText(
                        text: "Reset Password",
                        fontSize: 24,
                        fontFamily: "MontserratBold",
                        color: black),
                     SizedBox(height: 20),
                    _buildTextField(emailController, 'Email', Icons.email),
                     SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: _buildTextField(
                                otpController, 'OTP', Icons.password)),
                         SizedBox(width: 8),
                        Obx(() => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      controller
                                          .sendOtp(emailController.text.trim());
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yellow,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const MyText(
                                      text: 'Send OTP',
                                      color: white,
                                    ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                        passwordController, 'New Password', Icons.lock,
                        obscure: true),
                    const SizedBox(height: 10),
                    _buildTextField(confirmPasswordController,
                        'Confirm Password', Icons.lock_outline,
                        obscure: true),
                     SizedBox(height: 20),
                    Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    controller.resetPassword(
                                      emailController.text.trim(),
                                      otpController.text.trim(),
                                      passwordController.text.trim(),
                                      confirmPasswordController.text.trim(),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              padding:  EdgeInsets.symmetric(vertical: 15),
                              backgroundColor:  yellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const MyText(
                                    text: 'Reset Password',
                                    fontSize: 16,
                                    color: white,
                                    fontFamily: "MontserratBold",
                                  ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon:
            Icon(icon, color: black),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
