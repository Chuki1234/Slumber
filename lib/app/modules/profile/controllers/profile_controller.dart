import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../service/auth_service.dart';

class ProfileController extends GetxController {
  final userName = 'User_name'.obs;
  final avatarPath = 'assets/images/avatar.png'.obs;
  final AuthService _authService = AuthService();

  // 🔌 Bluetooth state
  RxBool isConnected = false.obs;
  RxBool isDeviceSupported = true
      .obs; // sẽ là false nếu chạy trên emulator (dùng để ẩn UI hoặc disable nút)
  BluetoothConnection? _connection;
  BluetoothDevice? _device;

  @override
  void onInit() {
    super.onInit();
    checkDeviceAndInitBluetooth(); // đảm bảo không khởi tạo trên emulator
  }

  /// ✅ Kiểm tra thiết bị thật hay emulator
  Future<void> checkDeviceAndInitBluetooth() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.isPhysicalDevice == false) {
        isDeviceSupported.value = false;
        Get.snackbar(
          "Unsupported",
          "Bluetooth is not supported on Android Emulator.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.black,
        );
        return;
      }
    }

    isDeviceSupported.value = true;
    await _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    try {
      if (Platform.isAndroid) {
        await [
          Permission.bluetooth,
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
          Permission.location,
        ].request();
      }

      await FlutterBluetoothSerial.instance.requestEnable();
    } catch (e) {
      Get.snackbar("Bluetooth", "Failed to enable Bluetooth: $e");
    }
  }

  /// 🔹 Connect to HC-05
  Future<void> connectToHC05() async {
    if (!isDeviceSupported.value) {
      Get.snackbar("Bluetooth", "Not supported on this device.");
      return;
    }

    try {
      final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      _device = devices.firstWhere((d) => d.name == 'HC-05');
    } catch (e) {
      Get.snackbar("Error", "HC-05 not paired.");
      return;
    }

    try {
      _connection = await BluetoothConnection.toAddress(_device!.address);
      isConnected.value = true;
      Get.snackbar("Bluetooth", "Connected to HC-05");
    } catch (e) {
      isConnected.value = false;
      Get.snackbar("Error", "Connection failed: $e");
    }
  }

  /// 🔹 Send data to HC-05
  void sendUserData({String userId = "default_user", int sessionId = 1}) {
    if (_connection != null && isConnected.value) {
      final data = "$userId,$sessionId\n";
      _connection!.output.add(Uint8List.fromList(data.codeUnits));
      Get.snackbar("Bluetooth", "Sent: $data");
    } else {
      Get.snackbar("Bluetooth", "Not connected to any device.");
    }
  }

  /// 🔹 Disconnect
  void disconnectBluetooth() {
    _connection?.dispose();
    _connection = null;
    isConnected.value = false;
    Get.snackbar("Bluetooth", "Disconnected");
  }

  /// 🔹 Sign out
  Future<void> SignOut() async {
    try {
      disconnectBluetooth();
      await _authService.signOut();
      Get.offAllNamed('/login');
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