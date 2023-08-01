import '../../../widgets/responsive.dart';
import '../../../../domain/chatbot/chat.dart';
import '../../../utils/color_helpers.dart';
import '../../../utils/font_style_helpers.dart';
import 'custom_tip.dart';
import 'package:flutter/material.dart';

class QuestionBubble extends StatelessWidget {
  final Chat chat;
  const QuestionBubble({required this.chat, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.isSmallScreen(context)
          ? const EdgeInsets.only(
              left: 10,
              right: 5,
              bottom: 10,
              top: 10,
            )
          : const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 15,
              top: 20,
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 3,
            child: SizedBox(),
          ),
          Flexible(
            flex: 7,
            child: Container(
              padding: Responsive.isSmallScreen(context)
                  ? const EdgeInsets.all(10)
                  : const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: primaryColor2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: SelectableText(
                chat.question,
                style: kHeading14.copyWith(
                  color: Colors.white,
                  fontSize: Responsive.isSmallScreen(context) ? 13 : 14,
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: CustomTip(primaryColor2),
          ),
        ],
      ),
    );
  }
}
