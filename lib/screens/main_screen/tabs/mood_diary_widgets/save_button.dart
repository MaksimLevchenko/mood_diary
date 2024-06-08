import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/app_style/utils.dart';
import 'package:mood_diary/models/person_mood.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  bool isButtonActive(BuildContext context) {
    final personMood = Provider.of<PersonMood>(context);
    if (personMood.pickedMoodIndex == null ||
        personMood.pickedEmotionIndex == null ||
        personMood.notes.isEmpty) {
      return false;
    }
    return true;
  }

  void onSave(BuildContext context) {
    final personMood = Provider.of<PersonMood>(context, listen: false);
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Все хорошо'),
          content: Column(
            children: [
              Text(
                  'Person mood: ${PersonMood.moods[personMood.pickedMoodIndex!].title}'),
              Text(
                  'Person emotion: ${PersonMood.emotions[personMood.pickedEmotionIndex!]}'),
              Text('Person stress: ${personMood.stressLevel}'),
              Text('Person self-assesment: ${personMood.selfAssessmentLevel}'),
              Text('Person notes: ${personMood.notes}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = isButtonActive(context);
    return Container(
      width: Sizes.buttonWidth,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: TextButton(
        onPressed: isActive ? () => onSave(context) : null,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color?>(
                isActive ? AppColors.tangerine : AppColors.gray4)),
        child: Text(
          'Сохранить',
          style: GoogleFonts.nunito(
            color: isActive ? Colors.white : AppColors.gray2,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
