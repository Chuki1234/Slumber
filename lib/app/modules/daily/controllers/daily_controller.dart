import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DailyController extends GetxController {
  final diaryText = ''.obs;
  final selectedTags = <String>[].obs;
  final selectedIcon = ''.obs;

  final diaryHistory = <String, String>{}.obs;
  final iconHistory = <String, String>{}.obs;
  final tagHistory = <String, List<String>>{}.obs;

  final diaryController = TextEditingController();

  final date = ''.obs;
  final time = ''.obs;
  final selectedDate = Rx<DateTime>(DateTime.now());
  final RxInt weekOffset = 0.obs;

  final availableTags = [
    {'emoji': '🤕', 'label': 'Pain'},
    {'emoji': '😴', 'label': 'Nap'},
    {'emoji': '🌕', 'label': 'Ate late'},
    {'emoji': '🧘‍♂️', 'label': 'Meditation'},
    {'emoji': '🤒', 'label': 'Sick'},
    {'emoji': '🍔', 'label': 'Heavy meal'},
    {'emoji': '🛁', 'label': 'Warm bath'},
    {'emoji': '💊', 'label': 'Sleeping pill'},
    {'emoji': '🍷', 'label': 'Alcohol'},
    {'emoji': '🏋️‍♂️', 'label': 'Workout'},
    {'emoji': '🧘‍♀️', 'label': 'Stretch'},
  ];

  final availableIcons = [
    '😴', '😊', '😢', '😠', '🥱', '💤', '😮‍💨', '❤️‍🩹',
    '😃', '😡', '😔', '🤯', '😭', '😍', '🤒', '🤢',
    '😇', '😵‍💫', '😩', '🤤', '😶', '😷', '😎', '🫠'
  ];

  @override
  void onInit() {
    super.onInit();
    updateDateTime();
    ever(selectedDate, (_) => loadDiaryForDate(selectedDate.value));
    loadAllFromStorage();
  }

  String get currentDateKey => DateFormat('yyyy-MM-dd').format(selectedDate.value);

  void updateDateTime() {
    final now = selectedDate.value;
    date.value = DateFormat('MMMM d, yyyy').format(now);
    time.value = DateFormat('jm').format(now);
  }


  void showTagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF2D1A47),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400), // 👈 Giới hạn chiều cao
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Take a note before sleep',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded( // 👈 Cho phép phần chọn tag scroll
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: availableTags.map((tag) {
                        final tagText = '${tag['emoji']} ${tag['label']}';
                        return Obx(() {
                          final isSelected = selectedTags.contains(tagText);
                          return GestureDetector(
                            onTap: () {
                              if (isSelected) {
                                selectedTags.remove(tagText);
                              } else {
                                selectedTags.add(tagText);
                              }
                              tagHistory[currentDateKey] = selectedTags.toList();
                              saveAllToStorage();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : const Color(0xFFB0A3D4).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                tagText,
                                style: TextStyle(
                                  color: isSelected ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Next', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Skip', style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void editDiaryText(BuildContext context) {
    diaryController.text = diaryText.value;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF2D1A47),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Diary",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: diaryController,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Write something to record this special day...',
                  hintStyle: const TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: const Color(0xFF3B2D58),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFB96EFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        diaryText.value = diaryController.text.trim();
                        diaryHistory[currentDateKey] = diaryText.value;
                        await saveAllToStorage();
                        Navigator.pop(context);
                      },
                      child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadDiaryForDate(DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    diaryText.value = diaryHistory[key] ?? '';
    selectedIcon.value = iconHistory[key] ?? '';
    selectedTags.assignAll(tagHistory[key] ?? []);
    updateDateTime();
  }

  Future<void> saveAllToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diaryHistory', jsonEncode(diaryHistory));
    await prefs.setString('iconHistory', jsonEncode(iconHistory));
    await prefs.setString('tagHistory', jsonEncode(tagHistory));
  }

  Future<void> loadAllFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final diaryStr = prefs.getString('diaryHistory');
    final iconStr = prefs.getString('iconHistory');
    final tagStr = prefs.getString('tagHistory');

    if (diaryStr != null) {
      final map = jsonDecode(diaryStr);
      diaryHistory.assignAll(map.map((k, v) => MapEntry(k, v.toString())));
    }
    if (iconStr != null) {
      final map = jsonDecode(iconStr);
      iconHistory.assignAll(map.map((k, v) => MapEntry(k, v.toString())));
    }
    if (tagStr != null) {
      final map = jsonDecode(tagStr);
      tagHistory.assignAll(map.map((k, v) => MapEntry(k, List<String>.from(v))));
    }

    loadDiaryForDate(selectedDate.value);
  }
}