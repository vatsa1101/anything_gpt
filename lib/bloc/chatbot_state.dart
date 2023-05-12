part of 'chatbot_bloc.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object> get props => [];
}

class EmptyChatbotState extends ChatbotState {}

class ChatbotInitialState extends ChatbotState {}

class ChatbotLoadingState extends ChatbotState {}

class ChatbotThinkingState extends ChatbotState {
  final Chat chat;

  const ChatbotThinkingState({required this.chat});

  @override
  List<Object> get props => [chat];
}

class ChatbotErrorState extends ChatbotState {
  final String error;

  const ChatbotErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class ChatbotThinkingErrorState extends ChatbotState {
  final String error;

  const ChatbotThinkingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class UserChatsLoadedState extends ChatbotState {
  final List<Chat> chats;

  const UserChatsLoadedState({
    required this.chats,
  });

  @override
  List<Object> get props => [chats];
}

class ChatbotAnsweredState extends ChatbotState {
  final Chat chat;

  const ChatbotAnsweredState({required this.chat});

  @override
  List<Object> get props => [chat];
}
