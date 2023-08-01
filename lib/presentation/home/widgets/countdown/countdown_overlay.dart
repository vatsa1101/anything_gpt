import '../../../../application/chatbot/chatbot_bloc.dart';
import 'custom_countdown.dart';
import '../../../utils/size_helpers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';

OverlayEntry? showCountdownOverlay({
  required BuildContext context,
  required String prompt,
}) {
  OverlayEntry? overlayEntry;
  OverlayState? overlayState = Overlay.of(context);
  overlayEntry = OverlayEntry(builder: (_) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () {
          overlayEntry?.remove();
          overlayEntry = null;
          context.read<ChatbotBloc>().add(BotCancelSendEvent());
        },
        child: Material(
          elevation: 0,
          color: Colors.black54,
          child: Container(
            height: context.height,
            width: context.width,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CountdownTimer(
                  endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 5,
                  onEnd: () {
                    if (overlayEntry != null) {
                      context.read<ChatbotBloc>().add(AskChatbotEvent(
                            question: prompt.trim(),
                          ));
                      overlayEntry?.remove();
                      overlayEntry = null;
                    }
                  },
                  widgetBuilder: (_, time) {
                    return CustomCountdown(time: time);
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const AutoSizeText(
                  "Tap To Cancel",
                  minFontSize: 1,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
  if (overlayEntry != null) {
    overlayState.insert(overlayEntry!);
  }
  return overlayEntry;
}
