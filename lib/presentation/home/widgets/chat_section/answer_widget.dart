import '../../../widgets/responsive.dart';
import '../../../../application/chatbot/chatbot_bloc.dart';
import '../../../../domain/chatbot/chat.dart';
import '../../../utils/font_style_helpers.dart';
import '../image/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnswerWidget extends StatelessWidget {
  final Chat chat;
  const AnswerWidget({required this.chat, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.isSmallScreen(context)
          ? const EdgeInsets.only(
              right: 20,
              bottom: 15,
              top: 10,
            )
          : const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
              top: 15,
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/bot.png",
            fit: BoxFit.contain,
            height: 30,
            width: 30,
          ),
          SizedBox(
            width: Responsive.isSmallScreen(context) ? 15 : 20,
          ),
          Flexible(
            flex: chat.answerType == AnswerType.text ? 7 : 2,
            child: chat.answer == null
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: LottieBuilder.asset(
                      "assets/animations/thinking.json",
                      height: 10,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : chat.answerType == AnswerType.text
                    ? chat.shouldType
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child: AnimatedTextKit(
                              key: const ValueKey("answer-animation"),
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  chat.answer!,
                                  textStyle: Responsive.isSmallScreen(context)
                                      ? kHeading13
                                      : kHeading14,
                                  speed: const Duration(milliseconds: 20),
                                ),
                              ],
                              isRepeatingAnimation: false,
                              onFinished: () {
                                context
                                    .read<ChatbotBloc>()
                                    .add(BotTypingFinishedEvent(
                                      chat: chat,
                                    ));
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child: SelectableText(
                              chat.answer,
                              style: Responsive.isSmallScreen(context)
                                  ? kHeading13
                                  : kHeading14,
                            ),
                          )
                    : Container(
                        alignment: Alignment.centerLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomImage(
                                      imageBytes: chat.answer[0],
                                      id: "${chat.id}_a0",
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomImage(
                                      imageBytes: chat.answer[1],
                                      id: "${chat.id}_a1",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomImage(
                                      imageBytes: chat.answer[2],
                                      id: "${chat.id}_a2",
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomImage(
                                      imageBytes: chat.answer[3],
                                      id: "${chat.id}_a3",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
          Responsive.isSmallScreen(context)
              ? const SizedBox()
              : const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
        ],
      ),
    );
  }
}
