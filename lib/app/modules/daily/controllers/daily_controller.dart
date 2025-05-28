import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class DailyController extends GetxController {
  final diaryText = ''.obs;
  final selectedTags = <String>[].obs;
  final diaryHistory = <String, String>{}.obs; // yyyy-MM-dd : note

  final availableTags = [
    '🧒 Sick',
    '🧘 Meditation',
    '🌙 Nightmares',
    '💤 Deep sleep'
  ];

  final diaryController = TextEditingController();

  final date = ''.obs;
  final time = ''.obs;
  final selectedDate = Rx<DateTime>(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    updateDateTime();
    ever(selectedDate, (_) => updateDateTime());
    loadFromLocal();
  }

  void updateDateTime() {
    final now = selectedDate.value;
    date.value = DateFormat('MMMM d, yyyy').format(now);
    time.value = DateFormat('jm').format(now);
  }

  void openDialog(BuildContext context) {
    diaryController.text = diaryText.value;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2B1545),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Diary", style: TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: diaryController,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Write something to record this special day...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF3C2A5D),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text(
                          "Cancel", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        saveDiaryNote();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text(
                          "Save", style: TextStyle(color: Colors.white)),
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

  Future<void> saveDiaryHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diary_history', jsonEncode(diaryHistory));
  }

  Future<void> loadDiaryHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('diary_history');
    if (historyString != null) {
      final Map<String, dynamic> map = jsonDecode(historyString);
      diaryHistory.assignAll(map.map((k, v) => MapEntry(k, v.toString())));
    }
  }

  Future<void> saveDiaryNote() async {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    diaryText.value = diaryController.text;
    diaryHistory[key] = diaryText.value;
    await saveToLocal();
  }

  Future<void> saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diary_note', diaryText.value);
    await prefs.setStringList('diary_tags', selectedTags.toList());
  }

  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    diaryText.value = prefs.getString('diary_note') ?? '';
    selectedTags.assignAll(prefs.getStringList('diary_tags') ?? []);
  }
}
