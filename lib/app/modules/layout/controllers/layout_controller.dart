import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController {
  final currentIndex = 0.obs;

  final List<Widget> pages;

  LayoutController({required this.pages});

  void changePage(int index) {
    currentIndex.value = index;
  }
}
