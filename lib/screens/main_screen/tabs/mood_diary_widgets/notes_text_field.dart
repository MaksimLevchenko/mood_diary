import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/app_style/utils.dart';
import 'package:mood_diary/models/person_mood.dart';
import 'package:provider/provider.dart';

class NotesTextField extends StatelessWidget {
  final TextEditingController notesController;

  const NotesTextField({
    super.key,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
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
          onTapOutside: (_) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          //Provider.of<PersonMood>(context).notes,
          onChanged: (value) {
            Provider.of<PersonMood>(context, listen: false).notes = value;
          },
        ),
      ),
    );
  }
}
