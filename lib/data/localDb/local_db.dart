import '../../domain/authentication/user.dart';
import '../../domain/chatbot/chat.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDb {
  static Box? data;

  static Future init() async {
    await Hive.initFlutter();
    data = await Hive.openBox("data");
  }

  static User? get user {
    return data?.get("user") != null ? User.fromMap(data!.get("user")) : null;
  }

  static get chats {
    if (data != null) {
      return data!.get("chats") ?? [];
    }
  }

  static Future saveUserDetails(User user) async {
    await data!.put('user', user.toMap());
  }

  static Future saveChat(Chat chat) async {
    List allChats = chats;
    allChats.add({
      "answer": chat.answer,
      "question": chat.question,
      "date": chat.date.millisecondsSinceEpoch,
      "id": chat.id,
      "answerType": answerTypeToString(chat.answerType),
    });
    await data!.put('chats', allChats);
  }

  static Future clearChat() async {
    if (data != null) {
      await data!.delete("chats");
    }
  }

  static Future clearUserData() async {
    if (data != null) {
      await data!.clear();
    }
  }
}
