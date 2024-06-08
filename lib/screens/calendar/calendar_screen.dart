import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:intl/intl.dart';
import 'package:mood_diary/app_style/images.dart';
import 'package:mood_diary/app_style/utils.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool isMonthesTab = true;

  void toggleTab() {
    setState(() {
      isMonthesTab = !isMonthesTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    CalendarBuilder pageBuilder = isMonthesTab
        ? MonthesBuilder(toggleTab: toggleTab)
        : YearBuilder(toggleTab: toggleTab);
    return Scaffold(
      appBar: appBar(context, pageBuilder),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: pageBuilder,
      ),
    );
  }

  PreferredSize appBar(BuildContext context, CalendarBuilder builder) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60 + builder.appBarHeight),
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            actions: [todayButton(builder.goToToday)],
            leading: closeButton(context),
            toolbarHeight: 40,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            forceMaterialTransparency: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: builder.appBar(),
          ),
        ],
      ),
    );
  }

  IconButton closeButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        AppImages.unionIconPath,
        color: AppColors.gray2,
        height: 16,
        width: 16,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  TextButton todayButton(void Function() onPressed) => TextButton(
      onPressed: onPressed,
      child: Text(
        'Сегодня',
        style: GoogleFonts.nunito(
            fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.gray2),
      ));
}

class CalendarBuilder extends StatelessWidget {
  final nowTime = DateTime.now();
  final void Function() toggleTab;
  CalendarBuilder({super.key, required this.toggleTab});

  Text monthTextTemplate(
    DateTime givenMonth,
    double fontSize,
    FontWeight fontWeight,
    Color color,
  ) {
    return Text(
      capitalize(DateFormat('LLLL', 'ru').format(givenMonth)),
      style: GoogleFonts.nunito(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  double get appBarHeight => 0;

  void goToToday() {
    throw UnimplementedError();
  }

  Widget appBar() {
    throw UnimplementedError();
  }

  Text yearTextTemplate(DateTime givenMonth, double fontSize,
      FontWeight fontWeight, Color color) {
    return Text(
      capitalize(DateFormat('yyyy', 'ru').format(givenMonth)),
      style: GoogleFonts.nunito(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  int getDaysInMonth(DateTime date) {
    DateTime firstDayOfNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);

    DateTime lastDayOfMonth =
        firstDayOfNextMonth.subtract(const Duration(seconds: 1));

    return lastDayOfMonth.day;
  }

  int getFirstDayOfMonthWeekday(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday;
  }

  String capitalize(String name) =>
      '${name[0].toUpperCase()}${name.substring(1)}';

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class MonthesBuilder extends CalendarBuilder {
  MonthesBuilder({super.key, required super.toggleTab});
  final Key forwardListKey = UniqueKey();
  final ScrollController monthScrollController = ScrollController();

  Widget forwardMonthesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        DateTime givenMonth = DateTime(nowTime.year, nowTime.month + index);
        return Column(
          children: [
            oneMonthWithTextBuilder(context, givenMonth),
            const SizedBox(height: Sizes.calendarHeightBetweenBigMonthes),
          ],
        );
      }),
      key: forwardListKey,
    );
  }

  Widget reverseMonthesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        DateTime givenMonth = DateTime(nowTime.year, nowTime.month - index - 1);
        return Column(
          children: [
            oneMonthWithTextBuilder(context, givenMonth),
            const SizedBox(height: Sizes.calendarHeightBetweenBigMonthes),
          ],
        );
      }),
    );
  }

  Widget oneMonthWithTextBuilder(context, DateTime givenMonth) {
    DateTime? selectedDay;
    if (nowTime.month == givenMonth.month && nowTime.year == givenMonth.year) {
      selectedDay = nowTime;
    }
    var firstWeekDay = getFirstDayOfMonthWeekday(givenMonth) - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: goToGivenYear,
          child: yearText(givenMonth),
        ),
        monthText(givenMonth),
        oneMonthBuilder(givenMonth, firstWeekDay, selectedDay),
      ],
    );
  }

  Text monthText(DateTime givenMonth) {
    return super
        .monthTextTemplate(givenMonth, 24, FontWeight.w700, AppColors.black);
  }

  Text yearText(DateTime givenMonth) {
    return super
        .yearTextTemplate(givenMonth, 16, FontWeight.w700, AppColors.gray2);
  }

  void goToGivenYear() {
    toggleTab();
  }

  @override
  void goToToday() {
    monthScrollController.animateTo(0,
        duration: Durations.short4, curve: Curves.easeInOut);
  }

  GridView oneMonthBuilder(
      DateTime givenMonth, int firstWeekDay, DateTime? selectedDay) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: getDaysInMonth(givenMonth) + firstWeekDay,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        bool isSelected = false;
        if (selectedDay != null) {
          isSelected = index + 1 == selectedDay.day + firstWeekDay;
        }
        return Container(
          width: 38.44,
          height: 38.44,
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.calendarTangerine : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(index + 1 - firstWeekDay) > 0 ? (index + 1 - firstWeekDay) : ''}',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              if (isSelected)
                Container(
                  width: 5,
                  height: 5.26,
                  decoration: BoxDecoration(
                    color: AppColors.tangerine,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  double get appBarHeight => 30.0;

  @override
  Widget appBar() {
    var textStyle = GoogleFonts.nunito(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.gray2,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('ПН', style: textStyle),
        Text('ВТ', style: textStyle),
        Text('СР', style: textStyle),
        Text('ЧТ', style: textStyle),
        Text('ПТ', style: textStyle),
        Text('СБ', style: textStyle),
        Text('ВС', style: textStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: monthScrollController,
      viewportBuilder: (context, offset) {
        return Viewport(
          offset: offset,
          center: forwardListKey,
          slivers: [
            reverseMonthesList(),
            forwardMonthesList(),
          ],
          cacheExtent: 6,
        );
      },
    );
  }
}

class YearBuilder extends CalendarBuilder {
  YearBuilder({super.key, required super.toggleTab});
  final forwardListKey = UniqueKey();
  final yearScrollController = ScrollController();

  @override
  void goToToday() {
    yearScrollController.animateTo(
      0,
      duration: Durations.short4,
      curve: Curves.easeInOut,
    );
  }

  Widget forwardMonthesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        DateTime givenYear = DateTime(
          nowTime.year + index,
        );
        return Column(
          children: [
            oneYearBuilder(givenYear),
            const SizedBox(height: Sizes.calendarHeightBetweenBigMonthes),
          ],
        );
      }),
      key: forwardListKey,
    );
  }

  Widget reverseMonthesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        DateTime givenYear = DateTime(nowTime.year - 1 - index);
        return Column(
          children: [
            oneYearBuilder(givenYear),
            const SizedBox(height: Sizes.calendarHeightBetweenBigMonthes),
          ],
        );
      }),
    );
  }

  GridView oneMonthBuilder(
      DateTime givenMonth, int firstWeekDay, DateTime? selectedDay) {
    if (selectedDay != null) {
      if (selectedDay.month == givenMonth.month &&
          selectedDay.year == givenMonth.year) {
        selectedDay = selectedDay;
      } else {
        selectedDay = null;
      }
    }
    return GridView.builder(
      shrinkWrap: true,
      itemCount: getDaysInMonth(givenMonth) + firstWeekDay,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        bool isSelected = false;
        if (selectedDay != null) {
          isSelected = index + 1 == selectedDay.day + firstWeekDay;
        }
        return Container(
          width: 17.21,
          height: 17.21,
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.calendarTangerine : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(index + 1 - firstWeekDay) > 0 ? (index + 1 - firstWeekDay) : ''}',
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  monthText(DateTime givenMonth) {
    return super
        .monthTextTemplate(givenMonth, 14, FontWeight.w700, AppColors.black);
  }

  Column oneMonthTextBuilder(
    DateTime givenMonth,
    int firstWeekDay,
    DateTime? selectedDay,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        monthText(givenMonth),
        oneMonthBuilder(givenMonth, firstWeekDay, selectedDay)
      ],
    );
  }

  @override
  double get appBarHeight => 0;

  Text yearText(DateTime givenMonth) {
    return super.yearTextTemplate(
      givenMonth,
      26,
      FontWeight.w800,
      AppColors.black,
    );
  }

  oneYearBuilder(DateTime givenYear) {
    return Column(
      children: [
        yearText(givenYear),
        const SizedBox(height: Sizes.calendarHeightBetweenBigMonthes),
        ...getYearRows(givenYear).map((_) {
          return Column(
            children: [
              _,
              const SizedBox(height: Sizes.calendarHeightBetweenBigMonthes),
            ],
          );
        }),
      ],
    );
  }

  List<Row> getYearRows(DateTime givenYear) {
    List<Row> rows = [];
    int year = givenYear.year;
    for (int i = 0; i < 12; i += 2) {
      DateTime month = DateTime(year, i + 1);
      DateTime nextMonth = DateTime(year, i + 2);
      rows.add(Row(
        children: [
          Expanded(
            child: oneMonthTextBuilder(
                month, getFirstDayOfMonthWeekday(month) - 1, nowTime),
          ),
          const SizedBox(width: Sizes.calendarGapBetweenSmallMonthes),
          Expanded(
            child: oneMonthTextBuilder(
                nextMonth, getFirstDayOfMonthWeekday(nextMonth) - 1, nowTime),
          ),
        ],
      ));
    }
    return rows;
  }

  @override
  Widget appBar() {
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleTab,
      child: Scrollable(
        controller: yearScrollController,
        viewportBuilder: (context, offset) {
          return Viewport(
            offset: offset,
            center: forwardListKey,
            slivers: [
              reverseMonthesList(),
              forwardMonthesList(),
            ],
            cacheExtent: 6,
          );
        },
      ),
    );
  }
}
