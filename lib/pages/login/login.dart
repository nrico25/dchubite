import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadchubite/pages/login/auth_controller.dart';
import 'package:tadchubite/widget/button.dart';
import 'package:tadchubite/widget/color.dart';
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

                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 8),

                CustomTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  borderColor: Colors.grey.shade300,
                  borderWidth: 1.0,
                  fillColor: Colors.white,
                  textColor: Colors.black,
                  hintColor: Colors.grey,
                ),

                SizedBox(height: 19),

                // Password Field
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 8),

                CustomTextField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  obscureText: true,
                  borderColor: Colors.grey.shade300,
                  borderWidth: 1.0,
                  fillColor: Colors.white,
                  textColor: Colors.black,
                  hintColor: Colors.grey,
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
                  elevation: 4,
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
