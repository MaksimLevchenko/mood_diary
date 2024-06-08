import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/app_style/utils.dart';
import 'package:mood_diary/models/person_mood.dart';
import 'package:mood_diary/widgets/dual_color_slider_shapes.dart';
import 'package:provider/provider.dart';

class DualColorSlider extends StatelessWidget {
  final BuildContext context;
  final double Function() getValue;
  final void Function(double) onChanged;
  final List<String> edgeNames;
  late final List<SizedBox> sticks;
  late final List<Text> edgeWidgets;

  DualColorSlider({
    super.key,
    required this.context,
    required this.getValue,
    required this.onChanged,
    required this.edgeNames,
  }) {
    sticks = getSticksForSlider();
    bool isActive = Provider.of<PersonMood>(context).pickedMoodIndex != null;
    edgeWidgets = getEdgesTextForSlider(edgeNames, isActive);
  }

  List<Text> getEdgesTextForSlider(List<String> edgeNames, bool isActive) {
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
    return edgeWidgets;
  }

  List<SizedBox> getSticksForSlider() {
    const int stickNum = 6;
    final List<SizedBox> sticks = List.generate(stickNum, (_) {
      return SizedBox.fromSize(
        size: Sizes.sliderBoxSticksSize,
        child: DecoratedBox(
          decoration: BoxDecoration(color: AppColors.gray5),
        ),
      );
    });
    return sticks;
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

  @override
  Widget build(BuildContext context) {
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
}
