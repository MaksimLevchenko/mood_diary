import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabSlider extends StatelessWidget {
  const TabSlider({
    super.key,
    required this.buttonNames,
    required this.buttonIcons,
    required this.selectedTab,
    required this.onTap,
    required this.toggleSize,
    required this.radius,
    required this.selectedFillColor,
    required this.unselectedFillColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
  });

  final List<String> buttonNames;
  final List<String> buttonIcons;
  final int selectedTab;
  final void Function(int) onTap;
  final Size toggleSize;
  final BorderRadius radius;
  final Color selectedFillColor;
  final Color unselectedFillColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        decoration:
            BoxDecoration(borderRadius: radius, color: unselectedFillColor),
        constraints: BoxConstraints.tight(toggleSize),
        child: Stack(
          children: [
            selectedTab == 1 ? leftButton() : rightButton(),
            selectedTab == 0 ? leftButton() : rightButton(),
          ],
        ));
  }

  Positioned rightButton() {
    return Positioned(
      right: 0,
      child: standartButton(1),
    );
  }

  InkWell standartButton(int buttonIndex) {
    return InkWell(
      borderRadius: radius,
      onTap: () => onTap(buttonIndex),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: radius,
            color: selectedTab == buttonIndex ? selectedFillColor : null),
        constraints: BoxConstraints(
            maxHeight: toggleSize.height, minHeight: toggleSize.height),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: tabData(
            name: buttonNames[buttonIndex],
            iconPath: buttonIcons[buttonIndex],
            isSelected: selectedTab == buttonIndex,
          ),
        ),
      ),
    );
  }

  Positioned leftButton() {
    return Positioned(left: 0, child: standartButton(0));
  }

  Row tabData(
      {required String name,
      required String iconPath,
      required bool isSelected}) {
    late final Color textColor;
    if (isSelected) {
      textColor = selectedTextColor;
    } else {
      textColor = unselectedTextColor;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          color: textColor,
          height: 12,
          width: 12,
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: GoogleFonts.nunito(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
