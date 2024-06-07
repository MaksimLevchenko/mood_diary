import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/app_style/utils.dart';
import 'package:mood_diary/models/person_mood.dart';
import 'package:provider/provider.dart';

class MoodDiaryTab extends StatelessWidget {
  const MoodDiaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMoodSelected =
        Provider.of<PersonMood>(context).pickedMoodIndex != null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        whatDoYouFeelText(),
        const SizedBox(height: 20),
        SizedBox(
          height: Sizes.moodBoxSize.height,
          child: OverflowBox(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: Sizes.moodBoxSize.height,
            child: moodsListView(context),
          ),
        ),
        SizedBox(height: 20),
        isMoodSelected ? emotionsSelection(context) : SizedBox.square(),
      ],
    );
  }

  Text whatDoYouFeelText() => Text(
        'Что чувствуешь?',
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.black,
        ),
      );

  Widget moodsListView(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (_, index) {
        return moodTile(context, index);
      },
      separatorBuilder: (_, i) => SizedBox(
        width: Sizes.moodBoxSeparatorWidth,
      ),
      itemCount: PersonMood.moods.length,
    );
  }

  Widget emotionsSelection(BuildContext context) {
    return Column(
      children: emotionsTileToRows(context),
    );
  }

  Widget emotionTile(BuildContext context, int index) {
    final bool isSelected =
        Provider.of<PersonMood>(context).pickedEmotionIndex == index;
    return GestureDetector(
      onTap: () => Provider.of<PersonMood>(context, listen: false)
          .pickedEmotionIndex = index,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.emotionBoxRadius),
            color: isSelected ? AppColors.tangerine : Colors.white,
            boxShadow: [AppColors.shadow]),
        child: Text(
          PersonMood.emotions[index],
          style: GoogleFonts.nunito(
              color: isSelected ? Colors.white : AppColors.black),
        ),
      ),
    );
  }

  List<Row> emotionsTileToRows(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double acceptableWidth =
        screenWidth - 40 - 60; // 60 - coefficient for beautyfulness

    List<double> elementsWidth = [];
    for (var element in PersonMood.emotions) {
      elementsWidth.add(element.length * 6.3 + 16);
    }

    List<List<Widget>> widgetsList = [[]];
    double rowElementsWidth = 0.0;
    for (int index = 0; index < PersonMood.emotions.length; index++) {
      if (elementsWidth[index] + rowElementsWidth > acceptableWidth) {
        widgetsList.add([
          SizedBox(
            height: 8,
          )
        ]);
        widgetsList.add([]);
        rowElementsWidth = 0.0;
      }
      rowElementsWidth += elementsWidth[index];
      widgetsList.last.add(emotionTile(context, index));
      widgetsList.last.add(SizedBox(width: 8));
    }
    return widgetsList.map((widgets) {
      return Row(
        children: widgets,
      );
    }).toList();
  }

  GestureDetector moodTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        onMoodChoose(context, index);
      },
      child: Container(
          constraints: BoxConstraints.loose(Sizes.moodBoxSize),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.moodBoxRadius),
              color: Colors.white,
              border: Border.all(
                  color:
                      Provider.of<PersonMood>(context).pickedMoodIndex == index
                          ? AppColors.tangerine
                          : Colors.white,
                  width: 2),
              boxShadow: [AppColors.shadow]),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  PersonMood.moods[index].imagePath,
                  height: 53,
                  width: 50,
                ),
                Text(
                  PersonMood.moods[index].title,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          )),
    );
  }

  void onMoodChoose(BuildContext context, int index) {
    Provider.of<PersonMood>(context, listen: false).pickedMoodIndex = index;
  }
}
