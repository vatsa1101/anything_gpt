import '../../../utils/color_helpers.dart';
import '../../../utils/font_style_helpers.dart';
import '../../../widgets/responsive.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

final List limitations = [
  "May occasionally generate incorrect information",
  "May occasionally generate incorrect images",
  "May occasionally produce harmful instructions or biased content",
];

class Limitations extends StatelessWidget {
  const Limitations({super.key});

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
                    Icons.warning_outlined,
                    color: primaryColor1,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    child: AutoSizeText(
                      "Limitations",
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
                    Icons.warning_outlined,
                    color: primaryColor1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: AutoSizeText(
                      "Limitations",
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
          children: limitations
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
