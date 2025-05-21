import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  void loginWithGoogle() {
    // Thực hiện đăng nhập Google tại đây
    Get.offAllNamed(Routes.LAYOUT); // chuyển qua layout khi đăng nhập thành công
  }
}
