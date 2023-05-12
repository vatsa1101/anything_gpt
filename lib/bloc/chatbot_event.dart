part of 'chatbot_bloc.dart';

abstract class ChatbotEvent extends Event {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

class EmptyChatbotEventEvent extends ChatbotEvent {}

class FetchUserChatsEvent extends ChatbotEvent {}

class AskChatbotEvent extends ChatbotEvent {
  final String question;
  final List<Chat> previousChats;

  const AskChatbotEvent({
    required this.question,
    required this.previousChats,
  });

  @override
  List<Object> get props => [question, previousChats];
}

class ResetChatsEvent extends ChatbotEvent {
  final List<Chat> chats;

  const ResetChatsEvent({
    required this.chats,
  });

  @override
  List<Object> get props => [chats];
}
