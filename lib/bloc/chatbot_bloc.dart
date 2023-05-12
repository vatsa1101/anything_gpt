import 'package:bloc/bloc.dart';
import '../domain/event.dart';
import '../domain/chat.dart';
import '../domain/chatlist.dart';
import '../infrastructure/api_repository.dart';
import '../infrastructure/local_db_hive.dart';
import '../main.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ApiRepository apiRepository = ApiRepository(url: baseUrl);
  ChatbotBloc(ChatbotState chatbotInitial) : super(chatbotInitial) {
    on<EmptyChatbotEventEvent>((event, emit) async {
      emit(EmptyChatbotState());
    });
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
        ),
      ));
      try {
        final response = await apiRepository.getResponse(event.question);
        final Chat chat = Chat(
          date: DateTime.now(),
          question: event.question.trim(),
          answer: "ok",
          id: const Uuid().v4(),
        );
        emit(ChatbotAnsweredState(
          chat: chat,
        ));
        await LocalDb.saveChat(chat);
      } catch (e) {
        emit(ChatbotThinkingErrorState(error: e.toString()));
      }
    });
    on<ResetChatsEvent>((event, emit) async {
      emit(ChatbotLoadingState());
      await LocalDb.clearUserData();
      add(FetchUserChatsEvent());
    });
  }
}
