import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            /// 🌀 Logo Slumber
            Image.asset(
              'assets/images/logo.png',
              width: 220, // ← phóng to
            ),

            const Spacer(flex: 3),

            /// 🔵 Nút Google
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A85),
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: controller.loginWithGoogle,
                child: Stack(
                  children: [
                    /// 📌 Text luôn nằm giữa
                    const Center(
                      child: Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    /// 📌 Icon Google sát trái
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Image.asset(
                          'assets/images/google.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
