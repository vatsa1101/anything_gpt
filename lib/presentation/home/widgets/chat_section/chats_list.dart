import '../../../../domain/chatbot/chat.dart';
import 'answer_widget.dart';
import 'question_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatsList extends StatelessWidget {
  final List<Chat> chats;
  const ChatsList({required this.chats, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      reverse: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) {
              return Padding(
                padding: i == 0 && chats.length > 1
                    ? const EdgeInsets.only(
                        top: 5,
                        bottom: 10,
                        left: 20,
                        right: 20,
                      )
                    : i == chats.length - 1
                        ? const EdgeInsets.only(
                            top: 48,
                            bottom: 5,
                            left: 20,
                            right: 20,
                          )
                        : const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: 20,
                            right: 20,
                          ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    chats[i].answer == null
                        ? QuestionBubble(
                            chat: chats[i],
                          ).animate().slideX(
                              curve: Curves.easeInOut,
                              begin: 0.4,
                              end: 0,
                              duration: const Duration(milliseconds: 500),
                            )
                        : QuestionBubble(
                            chat: chats[i],
                          ),
                    chats[i].answer == null
                        ? FutureBuilder(
                            future: Future.delayed(
                                const Duration(milliseconds: 700), () => true),
                            builder: (_, snap) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return SizeTransition(
                                    sizeFactor: animation,
                                    child: child,
                                  );
                                },
                                child: !snap.hasData
                                    ? const SizedBox()
                                    : AnswerWidget(
                                        chat: chats[i],
                                      ).animate().slideX(
                                          curve: Curves.easeInOut,
                                          delay:
                                              const Duration(milliseconds: 200),
                                          duration:
                                              const Duration(milliseconds: 700),
                                        ),
                              );
                            },
                          )
                        : AnswerWidget(
                            chat: chats[i],
                          ),
                  ],
                ),
              );
            },
            childCount: chats.length,
          ),
        ),
      ],
    );
  }
}
