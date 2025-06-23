import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../service/auth_service.dart';

class ProfileController extends GetxController {
  final userName = 'User_name'.obs;
  final avatarPath = 'assets/images/avatar.png'.obs;
  final AuthService _authService = AuthService();

  Future<void>SignOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed('/login'); // Adjust the route as needed
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}