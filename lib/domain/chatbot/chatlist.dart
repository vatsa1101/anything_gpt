import 'chat.dart';

class ChatList {
  final List<Chat> chats;

  ChatList({required this.chats});

  factory ChatList.fromJson(List<dynamic>? parsedJson) {
    List<Chat> chats = [];
    if (parsedJson != null) {
      chats = parsedJson.map((i) => Chat.fromJson(i)).toList();
      chats.sort((a, b) => a.date.millisecondsSinceEpoch
          .compareTo(b.date.millisecondsSinceEpoch));
      chats = chats.reversed.toList();
    }

    return ChatList(
      chats: chats,
    );
  }
}
