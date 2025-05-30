import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userName = 'User_name'.obs;
  final avatarPath = 'assets/images/avatar.png'.obs;

  void logout() {
    // Logic xử lý logout
    Get.offAllNamed('/login'); // hoặc Get.offAll(() => const LoginView());
  }
}