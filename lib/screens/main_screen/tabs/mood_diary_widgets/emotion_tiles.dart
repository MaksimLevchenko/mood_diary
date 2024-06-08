import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/app_style/utils.dart';
import 'package:mood_diary/models/person_mood.dart';
import 'package:provider/provider.dart';

class EmotionTiles extends StatelessWidget {
  const EmotionTiles({super.key});

  void onTap(int index, BuildContext context) {
    Provider.of<PersonMood>(context, listen: false).pickedEmotionIndex = index;
  }

  Widget emotionTile(BuildContext context, int index) {
    final bool isSelected =
        Provider.of<PersonMood>(context).pickedEmotionIndex == index;
    return GestureDetector(
      onTap: () => onTap(index, context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
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
    double acceptableWidth = screenWidth - 40;
    List<double> elementsWidth = [];
    for (var element in PersonMood.emotions) {
      elementsWidth.add(element.length * 6.55 + 16 + 16);
    }

    List<List<Widget>> widgetsList = [[]];
    double rowElementsWidth = 0.0;
    for (int index = 0; index < PersonMood.emotions.length; index++) {
      if (elementsWidth[index] + rowElementsWidth >= acceptableWidth) {
        widgetsList.add([const SizedBox(height: 8)]);
        widgetsList.add([]);
        rowElementsWidth = 0.0;
      }
      rowElementsWidth += elementsWidth[index];
      widgetsList.last.add(emotionTile(context, index));
      widgetsList.last.add(const SizedBox(width: 8));
    }
    return widgetsList.map((widgets) {
      return Row(
        children: widgets,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: emotionsTileToRows(context));
  }
}
