import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// 🌌 Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 📦 Main Content
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Column(
                  children: [
                    Container(
                      width: 120, // Adjust size as needed
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white24, // Background color
                        shape: BoxShape.circle, // Circular shape
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60, // Adjust icon size
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Text(
                      controller.userName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                ),

                const SizedBox(height: 60),

                /// ⚙️ Settings Container
                Padding(
                  padding: const EdgeInsets.only(top: 100), // Moves the container down by 40px
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1C46),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: const [
                            Icon(Icons.bluetooth, color: Colors.white),
                            SizedBox(width: 16),
                            Text(
                              'Connected',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white24, height: 32),
                        GestureDetector(
                          onTap: controller.logout,
                          child: Row(
                            children: const [
                              Icon(Icons.logout, color: Colors.white),
                              SizedBox(width: 16),
                              Text(
                                'Log out',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}