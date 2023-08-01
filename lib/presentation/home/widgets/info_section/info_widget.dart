import 'capabilities.dart';
import 'examples.dart';
import 'limitations.dart';
import '../../../widgets/responsive.dart';
import '../../../utils/font_style_helpers.dart';
import '../../../utils/size_helpers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: context.height * 0.1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Responsive.isSmallScreen(context)
                ? Image.asset(
                    "assets/images/bot.gif",
                    fit: BoxFit.contain,
                    height: context.height * 0.2,
                  )
                : LottieBuilder.asset(
                    "assets/animations/bot.json",
                    fit: BoxFit.contain,
                    height: context.height * 0.2,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AutoSizeText(
                "Ask Me Anything",
                style: s22kPcw600.copyWith(
                  fontSize: Responsive.isSmallScreen(context) ? 18 : 22,
                ),
                textAlign: TextAlign.center,
                minFontSize: 1,
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: context.height * 0.05,
            ),
            const Responsive(
              smallScreen: Column(
                children: [
                  Examples(),
                  SizedBox(
                    height: 15,
                  ),
                  Capabilities(),
                  SizedBox(
                    height: 15,
                  ),
                  Limitations(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              largeScreen: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Examples(),
                  ),
                  Expanded(
                    child: Capabilities(),
                  ),
                  Expanded(
                    child: Limitations(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
