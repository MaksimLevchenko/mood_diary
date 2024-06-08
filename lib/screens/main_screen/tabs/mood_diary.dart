import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/app_style/utils.dart';
import 'package:mood_diary/models/person_mood.dart';
import 'package:mood_diary/widgets/dual_color_slider_shapes.dart';
import 'package:provider/provider.dart';

class MoodDiaryTab extends StatelessWidget {
  const MoodDiaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMoodSelected =
        Provider.of<PersonMood>(context).pickedMoodIndex != null;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          whatDoYouFeelText(),
          const SizedBox(height: Sizes.distanceInElement),
          SizedBox(
            height: Sizes.moodBoxSize.height,
            child: OverflowBox(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: Sizes.moodBoxSize.height,
              child: moodsListView(context),
            ),
          ),
          isMoodSelected
              ? const SizedBox(height: Sizes.distanceInElement)
              : const SizedBox(),
          isMoodSelected ? emotionsSelection(context) : const SizedBox(),
          const SizedBox(height: Sizes.distanceBetweenElements),
          stressLevelText(),
          const SizedBox(height: Sizes.distanceInElement),
          stressSlider(context),
          const SizedBox(height: Sizes.distanceBetweenElements),
          selfAssumingText(),
          const SizedBox(height: Sizes.distanceInElement),
          selfAssumingSlider(context),
          const SizedBox(height: Sizes.distanceBetweenElements),
          notesText(),
          const SizedBox(height: Sizes.distanceInElement),
        ],
      ),
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

  Text stressLevelText() => Text(
        'Уровень стресса',
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.black,
        ),
      );

  Widget stressSlider(BuildContext context) {
    final personMood = Provider.of<PersonMood>(context);
    onChanged(value) {
      personMood.stressLevel = value;
    }

    return sliderBlockBuilder(context, () => personMood.stressLevel, onChanged,
        ['Низкий', 'Высокий']);
  }

  Text notesText() => Text(
        'Заметки',
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.black,
        ),
      );

  Text selfAssumingText() => Text(
        'Самооценка',
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.black,
        ),
      );

  Widget selfAssumingSlider(BuildContext context) {
    final personMood = Provider.of<PersonMood>(context);
    onChanged(value) {
      personMood.selfAssessment = value;
    }

    return sliderBlockBuilder(context, () => personMood.selfAssessment,
        onChanged, ['Неуверенность', 'Уверенность']);
  }

  Widget sliderBlockBuilder(
    BuildContext context,
    double Function() getValue,
    void Function(double) onChanged,
    List<String> edgeNames,
  ) {
    const int stickNum = 6;
    final List<SizedBox> sticks = List.generate(stickNum, (_) {
      return SizedBox.fromSize(
        size: Sizes.sliderBoxSticksSize,
        child: DecoratedBox(
          decoration: BoxDecoration(color: AppColors.gray5),
        ),
      );
    });
    bool isActive = Provider.of<PersonMood>(context).pickedMoodIndex != null;

    final List<Text> edgeWidgets = edgeNames.map(
      (e) {
        return Text(
          e,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w400,
            fontSize: 11,
            color: isActive ? AppColors.gray1 : AppColors.gray2,
          ),
        );
      },
    ).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.sliderBoxRadius),
        color: Colors.white,
        boxShadow: [AppColors.shadow],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: sticks,
            ),
          ),
          const SizedBox(height: 4),
          sliderBuilder(onChanged, getValue),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: edgeWidgets,
            ),
          )
        ],
      ),
    );
  }

  StatefulBuilder sliderBuilder(
      void Function(double) onChanged, double Function() getValue) {
    return StatefulBuilder(builder: (context, setState) {
      onSliderChange(value) {
        onChanged(value);
        setState(() {});
      }

      bool isActive = Provider.of<PersonMood>(context).pickedMoodIndex == null;
      return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          // thumbShape: SliderComponentShape.noThumb,
          thumbShape: DualColorThumbShape(
            enabledFirstThumbRadius: 18 / 2,
            enabledSecondThumbRadius: 10 / 2,
            firstColor: Colors.white,
            secondColor: isActive ? AppColors.gray5 : AppColors.tangerine,
          ),
          trackHeight: 6,
          overlayShape: SliderComponentShape.noOverlay,
          trackShape: const OneHeightTrackShape(32.0),
        ),
        child: Slider(
          value: getValue(),
          onChanged: isActive ? null : onSliderChange,
          activeColor: AppColors.tangerine,
          inactiveColor: AppColors.gray5,
          secondaryActiveColor: AppColors.gray5,
        ),
      );
    });
  }

  Widget moodsListView(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (_, index) {
        return moodTile(context, index);
      },
      separatorBuilder: (_, i) => const SizedBox(
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
                    color: AppColors.black,
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
