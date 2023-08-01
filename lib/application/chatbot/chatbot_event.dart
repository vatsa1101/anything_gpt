part of 'chatbot_bloc.dart';

abstract class ChatbotEvent extends Event {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

class FetchUserChatsEvent extends ChatbotEvent {}

class AskChatbotEvent extends ChatbotEvent {
  final String question;

  const AskChatbotEvent({
    required this.question,
  });

  @override
  List<Object> get props => [question];
}

class ResetChatsEvent extends ChatbotEvent {}

class BotTypingFinishedEvent extends ChatbotEvent {
  final Chat chat;

  const BotTypingFinishedEvent({
    required this.chat,
  });

  @override
  List<Object> get props => [chat];
}

class BotVoiceInputEvent extends ChatbotEvent {
  final bool isListening;

  const BotVoiceInputEvent({
    required this.isListening,
  });

  @override
  List<Object> get props => [isListening];
}

class BotListeningChangedEvent extends ChatbotEvent {
  final bool isListening;

  const BotListeningChangedEvent({
    required this.isListening,
  });

  @override
  List<Object> get props => [isListening];
}

class BotCancelSendEvent extends ChatbotEvent {}

class BotTextChangedEvent extends ChatbotEvent {
  final String text;

  const BotTextChangedEvent({
    required this.text,
  });

  @override
  List<Object> get props => [text];
}

class BotListeningErrorEvent extends ChatbotEvent {
  final String error;

  const BotListeningErrorEvent({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
