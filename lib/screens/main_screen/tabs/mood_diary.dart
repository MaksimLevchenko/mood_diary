import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/app_style/utils.dart';
import 'package:mood_diary/models/person_mood.dart';
import 'package:provider/provider.dart';

import 'mood_diary_widgets/dual_color_slider.dart';
import 'mood_diary_widgets/emotion_tiles.dart';
import 'mood_diary_widgets/mood_tiles.dart';

class MoodDiaryTab extends StatelessWidget {
  const MoodDiaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMoodSelected =
        Provider.of<PersonMood>(context).pickedMoodIndex != null;
    return Expanded(
      child: SingleChildScrollView(
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
                child: const MoodTiles(),
              ),
            ),
            isMoodSelected
                ? const SizedBox(height: Sizes.distanceInElement)
                : const SizedBox(),
            isMoodSelected ? const EmotionTiles() : const SizedBox(),
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
            notesTextField(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return const Placeholder();
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
    onChanged(value) => personMood.stressLevel = value;

    return DualColorSlider(
      context: context,
      getValue: () => personMood.stressLevel,
      onChanged: onChanged,
      edgeNames: const ['Низкий', 'Высокий'],
    );
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
    onChanged(value) => personMood.selfAssessment = value;

    return DualColorSlider(
      context: context,
      getValue: () => personMood.selfAssessment,
      onChanged: onChanged,
      edgeNames: const ['Неуверенность', 'Уверенность'],
    );
  }

  Widget notesTextField(BuildContext context) {
    TextEditingController textEditingController =
        TextEditingController(text: Provider.of<PersonMood>(context).notes);
    return ConstrainedBox(
      constraints:
          const BoxConstraints.expand(height: Sizes.notesTextFieldHeight),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [AppColors.shadow],
          borderRadius: BorderRadius.circular(Sizes.notesTextFieldRadius),
        ),
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: 'Введите заметку',
            hintStyle: GoogleFonts.nunito(
              color: AppColors.gray2,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.all(10),
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
          maxLines: null,
          style: GoogleFonts.nunito(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          onChanged: (value) {
            Provider.of<PersonMood>(context, listen: false).notes = value;
          },
        ),
      ),
    );
  }
}
