import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mood_diary/app_style/images.dart';

class PersonMood extends ChangeNotifier {
  static List<Mood> moods = [
    Mood(
      imagePath: AppImages.happinessImagePath,
      title: 'Hapiness',
    ),
    Mood(
      imagePath: AppImages.fearImagePath,
      title: 'Fear',
    ),
    Mood(
      imagePath: AppImages.madnessImagePath,
      title: 'Madness',
    ),
    Mood(
      imagePath: AppImages.sadnessImagePath,
      title: 'Sadness',
    ),
    Mood(
      imagePath: AppImages.calmnessImagePath,
      title: 'Calmness',
    ),
    Mood(
      imagePath: AppImages.powerImagePath,
      title: 'Powerful',
    ),
  ];

  static List<String> emotions = [
    'Возбуждение',
    'Восторг',
    'Игривость',
    'Наслаждение',
    'Очарование',
    'Осознанность',
    'Смелость',
    'Удовольствие',
    'Чувственность',
    'Энергичность',
    'Экстравагантность',
  ];

  int? _pickedMoodIndex;
  int? get pickedMoodIndex => _pickedMoodIndex;
  set pickedMoodIndex(int? value) {
    _pickedMoodIndex = value;
    notifyListeners();
  }

  int? _pickedEmotionIndex;
  int? get pickedEmotionIndex => _pickedEmotionIndex;
  set pickedEmotionIndex(int? value) {
    _pickedEmotionIndex = value;
    notifyListeners();
  }

  Double? stressLevel;

  double? selfAssessment;

  String? notes;
}

class Mood {
  final String imagePath;
  final String title;

  Mood({required this.imagePath, required this.title});
}
