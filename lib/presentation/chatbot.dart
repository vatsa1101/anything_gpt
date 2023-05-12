import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import '../bloc/chatbot_bloc.dart';
import '../presentation/widgets/custom_toast.dart';
import '../domain/chat.dart';
import '../presentation/helper/color_helpers.dart';
import '../presentation/helper/font_style_helpers.dart';
import '../presentation/helper/size_helpers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final FlutterTts tts = FlutterTts();
  bool isLoading = true;
  List<Chat> chats = [];
  final TextEditingController textController = TextEditingController();
  final SpeechToText speechToText = SpeechToText();
  bool isListening = false;
  bool speakerPlaying = false;
  String? currentSpeakerId;
  bool autoSpeak = true;
  Map<String, String> currentVoice = {
    "name": "Google UK English Female",
    "locale": "en-GB"
  };
  Timer? timer;
  bool voiceChanged = false;
  late FocusScopeNode currentFocus = FocusScope.of(context);

  // late final commentFocusNode = FocusNode(
  //   onKey: (FocusNode node, RawKeyEvent evt) {
  //     if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
  //       if (evt is RawKeyDownEvent) {
  //         sendPrompt();
  //       }
  //       return KeyEventResult.handled;
  //     } else {
  //       return KeyEventResult.ignored;
  //     }
  //   },
  // );

  Future<bool> toggleRecording({
    required Function(String text) onResult,
    required ValueChanged<bool> onListening,
  }) async {
    if (speechToText.isListening) {
      speechToText.stop();
      return true;
    }
    try {
      final isAvailable = await speechToText.initialize(
        onStatus: (status) => onListening(speechToText.isListening),
        onError: (e) {
          if (e.errorMsg == "error_no_match") {
            showErrorToast(
                context: context,
                error: "Speech not recognized, please try again.");
            return;
          }
          showErrorToast(context: context, error: e.errorMsg);
        },
      );

      if (isAvailable) {
        speechToText.listen(
          onResult: (value) => onResult(value.recognizedWords),
          listenMode: ListenMode.dictation,
          pauseFor: const Duration(seconds: 3),
        );
      } else {
        showErrorToast(context: context, error: "Not available");
      }
      return isAvailable;
    } catch (e) {
      showErrorToast(context: context, error: e.toString());
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    tts.setCancelHandler(() {
      setState(() {
        currentSpeakerId = null;
        speakerPlaying = false;
      });
    });
    tts.setCompletionHandler(() {
      setState(() {
        currentSpeakerId = null;
        speakerPlaying = false;
      });
    });
    tts.setPitch(1.15);
  }

  @override
  void dispose() {
    speechToText.cancel();
    textController.dispose();
    super.dispose();
  }

  Future<void> speak(String text) async {
    tts.speak(text);
  }

  Future<void> sendPrompt() async {
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (speakerPlaying) {
      tts.stop();
      setState(() {
        currentSpeakerId = null;
        speakerPlaying = false;
      });
    }
    if (textController.text.trim() != '') {
      context.read<ChatbotBloc>().add(AskChatbotEvent(
            question: textController.text,
            previousChats: chats,
          ));
      textController.clear();
    } else {
      showErrorToast(context: context, error: "Please enter some text first");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!voiceChanged) {
      voiceChanged = true;
      Future.delayed(const Duration(milliseconds: 200), () {
        // tts.setVoice(currentVoice);
      });
    }
    return BlocConsumer<ChatbotBloc, ChatbotState>(
      listener: (context, state) async {
        if (state is ChatbotLoadingState) {
          isLoading = true;
        }
        if (state is ChatbotErrorState) {
          isLoading = true;
        }
        if (state is UserChatsLoadedState) {
          chats = state.chats;
          isLoading = false;
        }
        if (state is ChatbotThinkingState) {
          chats.insert(0, state.chat);
        }
        if (state is ChatbotAnsweredState) {
          chats.removeAt(0);
          chats.insert(0, state.chat);
          // if (autoSpeak) {
          //   currentSpeakerId = state.chat.id;
          //   speakerPlaying = true;
          //   speak(state.chat.answer!);
          // }
        }
        if (state is ChatbotErrorState) {
          showErrorToast(context: context, error: state.error);
        }
        if (state is ChatbotThinkingErrorState) {
          showErrorToast(context: context, error: state.error);
          chats.removeAt(0);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: bgColor5,
            appBar: AppBar(
              backgroundColor: primaryColor2,
              title: AutoSizeText(
                "AnythingGPT",
                style: s22kPcw600.copyWith(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              actions: [
                InkWell(
                  onTap: () {
                    context
                        .read<ChatbotBloc>()
                        .add(ResetChatsEvent(chats: chats));
                  },
                  hoverColor: primaryColor1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AutoSizeText(
                      "Reset Chat",
                      style: s16kPcw400.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      minFontSize: 1,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                width: double.infinity,
                color: bgColor5,
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
                              ? Center(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: AutoSizeText.rich(
                                              const TextSpan(
                                                children: [
                                                  TextSpan(text: "Hii "),
                                                  TextSpan(
                                                    text: "👋",
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          "\nAsk Me Anything"),
                                                ],
                                              ),
                                              style: s22kPcw600,
                                              textAlign: TextAlign.center,
                                              minFontSize: 1,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  reverse: true,
                                  dragStartBehavior: DragStartBehavior.start,
                                  itemCount: chats.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: i == 0
                                          ? const EdgeInsets.only(
                                              top: 5,
                                              bottom: 10,
                                            )
                                          : i == chats.length - 1
                                              ? const EdgeInsets.only(
                                                  top: 15,
                                                  bottom: 5,
                                                )
                                              : const EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: primaryColor5,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 20,
                                                  bottom: 20,
                                                ),
                                                child: SelectableText(
                                                    chats[i].question,
                                                    style: kHeading14),
                                              ),
                                            ),
                                          ),
                                          chats[i].answer == null
                                              ? Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: LottieBuilder.asset(
                                                      "assets/images/thinking.json",
                                                      fit: BoxFit.fitHeight,
                                                      height: 20,
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 20,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: SelectableText(
                                                          chats[i].answer!,
                                                          style: kHeading14,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          if (speakerPlaying &&
                                                              currentSpeakerId ==
                                                                  chats[i].id) {
                                                            tts.stop();
                                                            setState(() {
                                                              currentSpeakerId =
                                                                  null;
                                                              speakerPlaying =
                                                                  false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              currentSpeakerId =
                                                                  chats[i].id;
                                                              speakerPlaying =
                                                                  true;
                                                            });
                                                            speak(chats[i]
                                                                .answer!);
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.volume_up,
                                                          color: speakerPlaying &&
                                                                  currentSpeakerId ==
                                                                      chats[i]
                                                                          .id
                                                              ? primaryColor2
                                                              : bgColor3,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 2,
                                bottom: 2,
                              ),
                              decoration: BoxDecoration(
                                color: bgColor4,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxHeight: displayHeight(context) * 0.2,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            TextField(
                                              autocorrect: true,
                                              enableSuggestions: true,
                                              maxLines: null,
                                              controller: textController,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Start typing...',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey.shade600,
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(
                                                    Icons.send,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    sendPrompt();
                                                  },
                                                ),
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
                          ),
                        ],
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     if (speakerPlaying) {
                    //       tts.stop();
                    //       setState(() {
                    //         currentSpeakerId = null;
                    //         speakerPlaying = false;
                    //       });
                    //     }
                    //     if (timer == null) {
                    //       setState(() {
                    //         timer?.cancel();
                    //         timer = null;
                    //         if (isListening) {
                    //           isListening = false;
                    //         }
                    //       });
                    //       toggleRecording(
                    //         onResult: (val) {
                    //           textController.text = val;
                    //         },
                    //         onListening: (val) {
                    //           setState(() {
                    //             bool temp = isListening;
                    //             isListening = val;
                    //             if (temp &&
                    //                 !isListening &&
                    //                 textController.text.isNotEmpty) {
                    //               timer = Timer.periodic(
                    //                 const Duration(seconds: 1),
                    //                 (time) {
                    //                   setState(() {
                    //                     if (time.tick == 3) {
                    //                       if (timer != null) {
                    //                         sendPrompt();
                    //                       }
                    //                       time.cancel();
                    //                       timer?.cancel();
                    //                       timer = null;
                    //                     }
                    //                   });
                    //                 },
                    //               );
                    //             }
                    //           });
                    //         },
                    //       );
                    //     }
                    //   },
                    //   child: AbsorbPointer(
                    //     absorbing: true,
                    //     child: isListening
                    //         ? const AvatarGlow(
                    //             endRadius: 68,
                    //             glowColor: primaryColor2,
                    //             child: FloatingActionButton(
                    //               heroTag: "mic",
                    //               backgroundColor: bgColor5,
                    //               onPressed: null,
                    //               child: Icon(
                    //                 Icons.mic,
                    //                 color: primaryColor2,
                    //               ),
                    //             ),
                    //           )
                    //         : const Padding(
                    //             padding: EdgeInsets.only(
                    //               left: 20,
                    //               right: 20,
                    //               top: 10,
                    //               bottom: 10,
                    //             ),
                    //             child: FloatingActionButton(
                    //               heroTag: "mic",
                    //               backgroundColor: primaryColor2,
                    //               onPressed: null,
                    //               child: Icon(
                    //                 Icons.mic,
                    //                 color: bgColor5,
                    //               ),
                    //             ),
                    //           ),
                    //   ),
                    // ),
                    // timer != null
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(
                    //           bottom: 10,
                    //         ),
                    //         child: InkWell(
                    //           onTap: () {
                    //             setState(() {
                    //               timer?.cancel();
                    //               timer = null;
                    //             });
                    //           },
                    //           child: AutoSizeText(
                    //             "Sending in ${3 - timer!.tick}\nClick to cancel",
                    //             style: s16kPcw400,
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //       )
                    //     : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
