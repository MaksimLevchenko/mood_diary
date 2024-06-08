import 'package:flutter/material.dart';
import 'package:mood_diary/app_style/images.dart';

class PersonMood extends ChangeNotifier {
  static List<Mood> moods = [
    Mood(
      imagePath: AppImages.happinessImagePath,
      title: 'Радость',
    ),
    Mood(
      imagePath: AppImages.fearImagePath,
      title: 'Страх',
    ),
    Mood(
      imagePath: AppImages.madnessImagePath,
      title: 'Бешенство',
    ),
    Mood(
      imagePath: AppImages.sadnessImagePath,
      title: 'Грусть',
    ),
    Mood(
      imagePath: AppImages.calmnessImagePath,
      title: 'Спокойствие',
    ),
    Mood(
      imagePath: AppImages.powerImagePath,
      title: 'Сила',
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

  double stressLevel = 0.5;

  double selfAssessmentLevel = 0.5;

  String _notes = '';
  String get notes => _notes;
  set notes(String value) {
    _notes = value;
    notifyListeners();
  }
}

class Mood {
  final String imagePath;
  final String title;

  Mood({required this.imagePath, required this.title});
}
