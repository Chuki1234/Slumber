import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final avatarUrl = user?.userMetadata?['avatar_url'] ?? '';
    final name = user?.userMetadata?['full_name'] ?? 'No Name';

    final userIdController = TextEditingController(text: "default_user");
    final sessionIdController = TextEditingController(text: "1");

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Column(
                      children: [
                        avatarUrl.isNotEmpty
                            ? CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(avatarUrl),
                        )
                            : Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Input Fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          TextField(
                            controller: userIdController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'User ID',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: sessionIdController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Session ID',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Bluetooth Settings
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A1C46),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bluetooth Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(() => Row(
                            children: [
                              const Icon(Icons.bluetooth,
                                  color: Colors.white),
                              const SizedBox(width: 16),
                              Text(
                                controller.isConnected.value
                                    ? 'Connected to HC-05'
                                    : 'Not connected',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.connectToHC05,
                            child: const Text('Connect to Bluetooth'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              final userId = userIdController.text.trim();
                              final sessionId = int.tryParse(
                                  sessionIdController.text.trim()) ??
                                  1;
                              controller.sendUserData(
                                  userId: userId, sessionId: sessionId);
                            },
                            child: const Text('Send Data'),
                          ),
                          const Divider(color: Colors.white24, height: 32),
                          GestureDetector(
                            onTap: controller.SignOut,
                            child: Row(
                              children: const [
                                Icon(Icons.logout, color: Colors.white),
                                SizedBox(width: 16),
                                Text(
                                  'Log out',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}