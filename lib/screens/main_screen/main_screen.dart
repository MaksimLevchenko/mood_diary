import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/app_style/images.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pickedTab = 1;

  String _getCurrentFormattedDate() {
    DateTime currentDate = DateTime.now();
    DateFormat formatter = DateFormat('d MMMM H:m');
    String formattedDate = formatter.format(currentDate);
    return formattedDate;
  }

  void _goToCalendar() {
    return;
  }

  Widget tabSlider() {
    return Placeholder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: titleClock(),
          centerTitle: true,
          actions: [calendarButton()],
        ),
        body: ListView(
          children: [
            tabSlider(),
          ],
        ));
  }

  IconButton calendarButton() {
    return IconButton(
      onPressed: _goToCalendar,
      icon: Image.asset(
        AppImages.calendarIconPath,
        color: AppColors.gray2,
      ),
    );
  }

  Text titleClock() {
    return Text(
      _getCurrentFormattedDate(),
      style: TextStyle(color: AppColors.gray2),
    );
  }
}
