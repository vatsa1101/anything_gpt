import '../domain/chat.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDb {
  static Box? user;

  static Future init() async {
    await Hive.initFlutter();
    user = await Hive.openBox("user");
  }

  static get chats {
    if (user != null) {
      return user!.get("chats") ?? [];
    }
  }

  static get name {
    if (user != null) {
      return user!.get("name") ?? "";
    }
  }

  static get location {
    if (user != null) {
      return user!.get("location") ?? "";
    }
  }

  static get petName {
    if (user != null) {
      return user!.get("petName") ?? "";
    }
  }

  static get petBreed {
    if (user != null) {
      return user!.get("petBreed") ?? "";
    }
  }

  static get petGender {
    if (user != null) {
      return user!.get("petGender") ?? "";
    }
  }

  static get petAge {
    if (user != null) {
      return user!.get("petAge") ?? "";
    }
  }

  static Future saveChat(Chat chat) async {
    List allChats = chats;
    allChats.add({
      "answer": chat.answer,
      "question": chat.question,
      "date": chat.date.millisecondsSinceEpoch,
      "id": chat.id,
    });
    await user!.put('chats', allChats);
  }

  static setName(name) async => await user!.put('name', name);

  static setLocation(location) async => await user!.put('location', location);

  static setPetName(petName) async => await user!.put('petName', petName);

  static setPetBreed(petBreed) async => await user!.put('petBreed', petBreed);

  static setPetGender(petGender) async =>
      await user!.put('petGender', petGender);

  static setPetAge(petAge) async => await user!.put('petAge', petAge);

  static Future clearUserData() async {
    if (user != null) {
      await user!.clear();
    }
  }
}
