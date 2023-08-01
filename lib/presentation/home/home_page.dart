import '../../application/authentication/authentication_bloc.dart';
import '../authentication/signin_popup.dart';
import 'widgets/countdown/countdown_overlay.dart';
import '../widgets/responsive.dart';
import 'widgets/info_section/info_widget.dart';
import 'widgets/chat_section/chats_list.dart';
import 'widgets/appbar/custom_appbar.dart';
import 'widgets/custom_textfield.dart';
import '../../application/chatbot/chatbot_bloc.dart';
import '../widgets/custom_toast.dart';
import '../../domain/chatbot/chat.dart';
import '../utils/color_helpers.dart';
import '../utils/font_style_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Chat> chats = [];
  final TextEditingController textController = TextEditingController();
  final SpeechToText speechToText = SpeechToText();
  late FocusScopeNode currentFocus = FocusScope.of(context);
  FocusNode? textfieldFocusNode;
  bool isError = false;
  bool initDone = false;
  late final SpeechToTextProvider provider;
  bool isSpeechAvailable = false;
  bool speechSetted = false;
  bool isMicListening = false;
  bool isMicEnabled = true;
  bool isSendEnabled = false;
  bool textFieldEnabled = true;
  bool isMicLoading = false;

  Future<void> initialize(BuildContext context) async {
    isSpeechAvailable = await provider.initialize();
    provider.addListener(() {
      if (provider.hasResults && isMicListening) {
        if (provider.lastResult != null) {
          textController.text = provider.lastResult!.recognizedWords;
          context.read<ChatbotBloc>().add(
              BotTextChangedEvent(text: provider.lastResult!.recognizedWords));
          if (provider.lastResult!.finalResult) {
            context.read<ChatbotBloc>().add(
                BotListeningChangedEvent(isListening: provider.isListening));
          }
        }
        return;
      }
      if (isMicListening != provider.isListening) {
        context
            .read<ChatbotBloc>()
            .add(BotListeningChangedEvent(isListening: provider.isListening));
        return;
      }
      if (provider.hasError && isMicListening) {
        if (provider.lastError != null) {
          if (provider.lastError!.errorMsg == "error_no_match" ||
              provider.lastError!.errorMsg == "error_no_speech" ||
              provider.lastError!.errorMsg == "error_retry") {
            context.read<ChatbotBloc>().add(const BotListeningErrorEvent(
                error: "Speech not recognized, please try again."));
            return;
          }
          context
              .read<ChatbotBloc>()
              .add(BotListeningErrorEvent(error: provider.lastError!.errorMsg));
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!speechSetted) {
      speechSetted = true;
      provider = Provider.of<SpeechToTextProvider>(context);
    }
  }

  @override
  void dispose() {
    speechToText.cancel();
    textController.dispose();
    textfieldFocusNode?.dispose();
    currentFocus.dispose();
    super.dispose();
  }

  Future<void> sendPrompt(BuildContext ctx) async {
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (!ctx.read<AuthenticationBloc>().isSignedIn) {
      showSignInPopup(ctx);
      return;
    }
    if (textController.text.trim() != '') {
      ctx.read<ChatbotBloc>().add(AskChatbotEvent(
            question: textController.text.trim(),
          ));
      textController.clear();
    } else {
      showErrorToast(context: ctx, error: "Please enter some text first");
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocProvider(
      create: (context) =>
          ChatbotBloc(ChatbotInitialState())..add(FetchUserChatsEvent()),
      child: BlocConsumer<ChatbotBloc, ChatbotState>(
        listener: (context, state) {
          if (state is ChatbotLoadingState) {
            isLoading = true;
            isError = false;
          }
          if (state is ChatbotErrorState) {
            isLoading = true;
            isError = false;
            showErrorToast(context: context, error: "Something went wrong");
          }
          if (state is UserChatsLoadedState) {
            chats = state.chats;
            isLoading = false;
            isError = false;
            isMicEnabled = true;
            isSendEnabled = false;
            textFieldEnabled = true;
            isMicListening = false;
          }
          if (state is ChatbotThinkingState) {
            isMicEnabled = false;
            isSendEnabled = false;
            textFieldEnabled = false;
            isMicListening = false;
            textController.clear();
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            chats.where((e) => e.shouldType).forEach((e) {
              e.shouldType = false;
            });
            chats.insert(0, state.chat);
          }
          if (state is ChatbotAnsweredState) {
            isMicEnabled = false;
            isSendEnabled = false;
            textFieldEnabled = false;
            isMicListening = false;
            chats.removeWhere((e) => e.answer == null);
            chats.insert(0, state.chat);
          }
          if (state is BotVoiceInputStopState) {
            isMicListening = false;
            provider.cancel();
            isMicEnabled = true;
            textFieldEnabled = true;
            if (textController.text.isNotEmpty &&
                textController.text.trim() != "") {
              isSendEnabled = true;
            } else {
              isSendEnabled = false;
            }
          }
          if (state is BotVoiceInputStartedState) {
            isMicLoading = true;
            isMicEnabled = false;
            isSendEnabled = false;
            textFieldEnabled = false;
            try {
              if (isSpeechAvailable) {
                provider.listen(
                  pauseFor: const Duration(seconds: 3),
                );
              } else {
                showErrorToast(context: context, error: "Not available");
              }
            } catch (e) {
              showErrorToast(context: context, error: e.toString());
            }
          }
          if (state is BotListeningChangedState) {
            bool temp = isMicListening;
            isMicListening = state.isListening;
            isMicLoading = false;
            if (isMicListening) {
              isMicEnabled = true;
            }
            if (temp &&
                !isMicListening &&
                textController.text.isNotEmpty &&
                textController.text.trim() != "") {
              showCountdownOverlay(
                context: context,
                prompt: textController.text,
              );
              isMicEnabled = false;
              isSendEnabled = false;
              textFieldEnabled = false;
              isMicListening = false;
            } else if (temp &&
                !isMicListening &&
                (textController.text.isEmpty ||
                    textController.text.trim() == "")) {
              isMicListening = false;
              isMicEnabled = true;
              textFieldEnabled = true;
              if (textController.text.isNotEmpty &&
                  textController.text.trim() != "") {
                isSendEnabled = true;
              } else {
                isSendEnabled = false;
              }
            }
          }
          if (state is ChatbotThinkingErrorState) {
            isError = true;
            isMicEnabled = true;
            textFieldEnabled = true;
            isMicListening = false;
            if (textController.text.isNotEmpty &&
                textController.text.trim() != "") {
              isSendEnabled = true;
            } else {
              isSendEnabled = false;
            }
            showErrorToast(context: context, error: "Something went wrong");
            chats.removeWhere((e) => e.answer == null);
          }
          if (state is BotTypingFinishedState) {
            state.chat.shouldType = false;
            isMicEnabled = true;
            textFieldEnabled = true;
            isMicListening = false;
            if (textController.text.isNotEmpty &&
                textController.text.trim() != "") {
              isSendEnabled = true;
            } else {
              isSendEnabled = false;
            }
          }
          if (state is BotCancelSendState) {
            isMicEnabled = true;
            textFieldEnabled = true;
            isMicListening = false;
            if (textController.text.isNotEmpty &&
                textController.text.trim() != "") {
              isSendEnabled = true;
            } else {
              isSendEnabled = false;
            }
          }
          if (state is BotTextChangedState) {
            if (textController.text.isNotEmpty &&
                textController.text.trim() != "") {
              isSendEnabled = true;
            } else {
              isSendEnabled = false;
            }
          }
          if (state is BotListeningErrorState) {
            showErrorToast(context: context, error: state.error);
            if (provider.isListening) {
              isMicListening = false;
              provider.cancel();
            }
          }
        },
        builder: (context, state) {
          if (!initDone) {
            initDone = true;
            initialize(context);
          }
          textfieldFocusNode ??= FocusNode(
            onKey: (FocusNode node, RawKeyEvent evt) {
              if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
                if (evt is RawKeyDownEvent) {
                  sendPrompt(context);
                }
                return KeyEventResult.handled;
              } else {
                return KeyEventResult.ignored;
              }
            },
          );
          return GestureDetector(
            onTap: () {
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: bgColor,
              extendBodyBehindAppBar: true,
              appBar: const CustomAppbar(),
              body: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 800,
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Expanded(
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor2,
                                      ),
                                    )
                                  : chats.isEmpty
                                      ? const InfoWidget()
                                      : ChatsList(
                                          chats: chats,
                                        ),
                            ),
                            CustomTextfield(
                              textEditingController: textController,
                              focusNode: textfieldFocusNode!,
                              onSend: () => sendPrompt(context),
                              isTextfieldEnabled: textFieldEnabled,
                              isSendEnabled: isSendEnabled,
                              isMicEnabled: isMicEnabled,
                              isMicListening: isMicListening,
                              isMicLoading: isMicLoading,
                            ),
                            Padding(
                              padding: Responsive.isSmallScreen(context)
                                  ? const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      bottom: 10,
                                    )
                                  : const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 15,
                                    ),
                              child: AutoSizeText(
                                "This is currently in development stage and may produce inaccurate information and images",
                                style: kHeading12.copyWith(
                                  color: Colors.grey.shade600,
                                  fontSize: Responsive.isSmallScreen(context)
                                      ? 10
                                      : 12,
                                ),
                                maxLines: 2,
                                minFontSize: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
