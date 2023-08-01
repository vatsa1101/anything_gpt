import '../../domain/utils/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../domain/utils/event.dart';
import '../../domain/chatbot/chat.dart';
import '../../domain/chatbot/chatlist.dart';
import '../../data/repository/api_repository.dart';
import '../../data/localDb/local_db.dart';
import 'package:equatable/equatable.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ApiRepository apiRepository =
      ApiRepository(url: FirebaseRemoteConfig.instance.getString("base_url"));
  ChatbotBloc(ChatbotState chatbotInitial) : super(chatbotInitial) {
    on<FetchUserChatsEvent>((event, emit) async {
      emit(ChatbotLoadingState());
      try {
        final chats = ChatList.fromJson(LocalDb.chats).chats;
        emit(UserChatsLoadedState(
          chats: chats,
        ));
      } catch (e) {
        emit(ChatbotErrorState(error: e.toString()));
      }
    });
    on<AskChatbotEvent>((event, emit) async {
      emit(ChatbotThinkingState(
        chat: Chat(
          date: DateTime.now(),
          question: event.question,
          id: "0",
          answerType: AnswerType.text,
        ),
      ));
      try {
        final response = await apiRepository.getResponse(event.question);
        Chat chat = Chat(
          date: DateTime.now(),
          question: event.question.trim(),
          id: DateTime.now().toString(),
          shouldType: true,
        );
        chat.update(response);
        emit(ChatbotAnsweredState(
          chat: chat,
        ));
        await LocalDb.saveChat(chat);
      } catch (e) {
        emit(ChatbotThinkingErrorState(error: e.toString()));
        logger.e(e.toString());
      }
    });
    on<ResetChatsEvent>((event, emit) async {
      emit(ChatbotLoadingState());
      await LocalDb.clearChat();
      add(FetchUserChatsEvent());
    });
    on<BotTypingFinishedEvent>((event, emit) async {
      emit(BotTypingFinishedState(
        chat: event.chat,
      ));
    });
    on<BotVoiceInputEvent>((event, emit) {
      if (event.isListening) {
        emit(BotVoiceInputStopState());
      } else {
        emit(BotVoiceInputStartedState());
      }
    });
    on<BotListeningChangedEvent>((event, emit) async {
      emit(BotListeningChangedState(
        isListening: event.isListening,
      ));
    });
    on<BotCancelSendEvent>((event, emit) async {
      emit(BotCancelSendState());
    });
    on<BotTextChangedEvent>((event, emit) async {
      emit(BotTextChangedState(
        text: event.text,
      ));
    });
    on<BotListeningErrorEvent>((event, emit) async {
      emit(BotListeningErrorState(
        error: event.error,
      ));
    });
  }
}
