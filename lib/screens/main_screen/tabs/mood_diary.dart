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
        return listTile(context, index);
      },
      separatorBuilder: (_, i) => SizedBox(
        width: Sizes.moodBoxSeparatorWidth,
      ),
      itemCount: PersonMood.moods.length,
    );
  }

  GestureDetector listTile(BuildContext context, int index) {
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
