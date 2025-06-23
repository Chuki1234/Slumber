import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../service/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();


  Future<void> signInWithGoogle() async {
    try {
      await _authService.nativeGoogleSignIn();
      Get.offAllNamed(Routes.LAYOUT); // Navigate to layout after login
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
