import '../../../application/authentication/authentication_bloc.dart';
import '../../../application/chatbot/chatbot_bloc.dart';
import '../../authentication/signin_popup.dart';
import '../../utils/color_helpers.dart';
import '../../utils/font_style_helpers.dart';
import '../../widgets/responsive.dart';
import '../../utils/size_helpers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function() onSend;
  final bool isTextfieldEnabled;
  final bool isSendEnabled;
  final bool isMicEnabled;
  final bool isMicListening;
  final bool isMicLoading;
  const CustomTextfield({
    required this.textEditingController,
    required this.focusNode,
    required this.onSend,
    required this.isTextfieldEnabled,
    required this.isSendEnabled,
    required this.isMicEnabled,
    required this.isMicListening,
    required this.isMicLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.isSmallScreen(context)
          ? const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 10,
            )
          : const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
      child: Container(
        padding: const EdgeInsets.only(
          left: 16,
          top: 2,
          bottom: 2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFBEBEBE),
              offset: Offset(3, 3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-3, -3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: context.height * 0.2,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        enabled: isTextfieldEnabled,
                        autocorrect: true,
                        enableSuggestions: true,
                        maxLines: null,
                        focusNode: focusNode,
                        controller: textEditingController,
                        style: Responsive.isSmallScreen(context)
                            ? kHeading12
                            : kHeading13,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Start typing...',
                          hintStyle: Responsive.isSmallScreen(context)
                              ? kHeading12
                              : kHeading13,
                        ),
                        onChanged: (val) {
                          context
                              .read<ChatbotBloc>()
                              .add(BotTextChangedEvent(text: val));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.isSmallScreen(context) ? 10 : 20,
                right: Responsive.isSmallScreen(context) ? 0 : 5,
                bottom: 4,
              ),
              child: MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                child: GestureDetector(
                  onTap: isMicEnabled
                      ? () {
                          if (!context.read<AuthenticationBloc>().isSignedIn) {
                            showSignInPopup(context);
                            return;
                          }
                          context.read<ChatbotBloc>().add(
                              BotVoiceInputEvent(isListening: isMicListening));
                        }
                      : null,
                  child: AbsorbPointer(
                    absorbing: true,
                    child: isMicListening
                        ? const IconButton(
                            onPressed: null,
                            icon: SizedBox(
                              height: 24,
                              width: 24,
                              child: OverflowBox(
                                maxHeight: 60,
                                minHeight: 60,
                                maxWidth: 60,
                                minWidth: 60,
                                child: AvatarGlow(
                                  endRadius: 60,
                                  glowColor: primaryColor4,
                                  repeatPauseDuration: Duration.zero,
                                  child: Icon(
                                    Icons.mic,
                                    color: primaryColor2,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: IconButton(
                              onPressed: null,
                              tooltip: "Ask with your voice",
                              icon: isMicLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: primaryColor2,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.mic,
                                      color: textColor1,
                                    ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 4,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: textColor1,
                ),
                tooltip: "Click To Send",
                onPressed: isSendEnabled ? onSend : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
