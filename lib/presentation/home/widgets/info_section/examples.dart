import '../../../../application/authentication/authentication_bloc.dart';
import '../../../../application/chatbot/chatbot_bloc.dart';
import '../../../authentication/signin_popup.dart';
import '../../../utils/color_helpers.dart';
import '../../../utils/font_style_helpers.dart';
import '../../../widgets/responsive.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List examples = [
  "Explain artificial intelligence in simple terms",
  "Got any creative ideas for a 10 year old's birthday?",
  "Generate an image of red mustang with tyre smoke",
];

class Examples extends StatelessWidget {
  const Examples({super.key});

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
                    Icons.lightbulb,
                    color: primaryColor1,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    child: AutoSizeText(
                      "Examples",
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
                    Icons.lightbulb,
                    color: primaryColor1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: AutoSizeText(
                      "Examples",
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
          children: examples
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!context.read<AuthenticationBloc>().isSignedIn) {
                        showSignInPopup(context);
                        return;
                      }
                      context.read<ChatbotBloc>().add(AskChatbotEvent(
                            question: e,
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor6,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: Padding(
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
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
