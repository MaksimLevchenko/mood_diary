import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/app_style/images.dart';
import 'package:mood_diary/app_style/utils.dart';
import 'package:mood_diary/screens/main_screen/tabs/mood_diary.dart';
import 'package:mood_diary/screens/main_screen/tabs/statistic.dart';
import 'package:mood_diary/widgets/tab_buttons.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey tabBarKey = GlobalKey();
  final List<String> tabsNames = [
    'Дневник настроения',
    'Статистика',
  ];
  final List<String> tabsIcons = [
    AppImages.diaryIconPath,
    AppImages.statisticIconPath,
  ];
  int selectedTab = 0;

  String _getCurrentFormattedDate() {
    DateTime currentDate = Provider.of<DateTime>(context);
    DateFormat formatter = DateFormat('d MMMM HH:mm');
    String formattedDate = formatter.format(currentDate);
    return formattedDate;
  }

  IconButton calendarButton() {
    return IconButton(
      onPressed: _goToCalendar,
      icon: Image.asset(
        AppImages.calendarIconPath,
        color: AppColors.gray2,
        width: 24,
        height: 24,
      ),
    );
  }

  Text _titleClock() {
    return Text(
      _getCurrentFormattedDate(),
      style: GoogleFonts.nunito(
        color: AppColors.gray2,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _goToCalendar() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _titleClock(),
        centerTitle: true,
        actions: [calendarButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Center(child: tabSelectWidget()),
          const SizedBox(height: 30),
          selectedTab == 0 ? const MoodDiaryTab() : const StatisticTab(),
        ]),
      ),
    );
  }

  Widget tabSelectWidget({GlobalKey? key}) {
    return TabButtons(
      buttonIcons: tabsIcons,
      buttonNames: tabsNames,
      selectedTab: selectedTab,
      radius: BorderRadius.circular(Sizes.tabBarRadius),
      toggleSize: Sizes.toggleSize,
      onTap: onToggleTap,
      selectedFillColor: AppColors.tangerine,
      unselectedFillColor: AppColors.gray4,
      selectedTextColor: Colors.white,
      unselectedTextColor: AppColors.gray2,
      key: key,
    );
  }

  void onToggleTap(index) {
    selectedTab = index;
    setState(() {});
  }
}
