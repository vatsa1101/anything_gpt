import '../../../utils/color_helpers.dart';
import '../../../utils/font_style_helpers.dart';
import '../../../widgets/responsive.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

final List capabilities = [
  "Generates images from text prompt",
  "Trained to decline inappropriate requests",
];

class Capabilities extends StatelessWidget {
  const Capabilities({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Responsive.isSmallScreen(context)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.flash_on,
                    color: primaryColor1,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    child: AutoSizeText(
                      "Capabilities",
                      style: kHeading18w600.copyWith(
                        color: primaryColor1,
                        fontWeight: Responsive.isSmallScreen(context)
                            ? FontWeight.w500
                            : FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      minFontSize: 1,
                      maxLines: 1,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  const Icon(
                    Icons.flash_on,
                    color: primaryColor1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: AutoSizeText(
                      "Capabilities",
                      style: kHeading18w600.copyWith(
                        color: primaryColor1,
                      ),
                      textAlign: TextAlign.center,
                      minFontSize: 1,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
        Column(
          children: capabilities
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryColor6,
                    ),
                    padding: Responsive.isSmallScreen(context)
                        ? const EdgeInsets.all(15)
                        : const EdgeInsets.all(10),
                    child: AutoSizeText(
                      e,
                      textAlign: TextAlign.center,
                      style: kHeading13.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
