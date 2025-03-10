import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/color.dart';
import 'package:tadchubite/widget/text.dart';
import 'package:tadchubite/widget/textfield.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/dchubitelogo.png',
                    height: 190,
                    width: 190,
                  ),
                ),
                SizedBox(height: 40),
                MyText(
                  text: "Username",
                  fontFamily: "MontserratBold",
                  fontSize: 16,
                ),
                SizedBox(height: 8),
                CustomTextField(
                  width: 400,
                  controller: emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  borderColor: Colors.grey.shade300,
                  borderWidth: 1.0,
                  fillColor: white,
                  textColor: black,
                  hintColor: grey,
                ),
                SizedBox(height: 19),
                MyText(
                  text: "Password",
                  fontFamily: "MontserratBold",
                  fontSize: 16,
                ),
                SizedBox(height: 8),
                CustomTextField(
                  width: 400,
                  controller: passwordController,
                  hintText: 'Enter your password',
                  obscureText: true,
                  borderColor: Colors.grey.shade300,
                  borderWidth: 1.0,
                  fillColor: white,
                  textColor: black,
                  hintColor: grey,
                ),
                SizedBox(height: 20),
                MyButton(
                  text: 'Login',
                  onPressed: () {
                    authController.login(
                        emailController.text, passwordController.text);
                  },
                  color: yellow,
                  height: 56,
                  elevation: 0,
                  borderRadius: 12,
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
