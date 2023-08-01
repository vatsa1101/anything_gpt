import 'dart:collection';
import 'dart:convert';

enum AnswerType { image, text }

AnswerType answerTypeFromResponse(dynamic response) {
  if (response["text"] != null) {
    return AnswerType.text;
  }
  return AnswerType.image;
}

AnswerType answerTypeFromString(String answerType) {
  switch (answerType) {
    case "image":
      return AnswerType.image;
    case "text":
      return AnswerType.text;
    default:
      return AnswerType.text;
  }
}

String answerTypeToString(AnswerType answerType) {
  switch (answerType) {
    case AnswerType.image:
      return "image";
    case AnswerType.text:
      return "text";
  }
}

class Chat {
  final String id;
  final String question;
  dynamic answer;
  final DateTime date;
  AnswerType answerType;
  bool shouldType;

  Chat({
    required this.id,
    this.answer,
    required this.date,
    required this.question,
    this.answerType = AnswerType.text,
    this.shouldType = false,
  });

  factory Chat.fromJson(LinkedHashMap<dynamic, dynamic> json) {
    return Chat(
      id: json["id"],
      answer: json["answer"],
      date: json["date"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["date"])
          : DateTime.now(),
      question: json["question"],
      answerType: answerTypeFromString(json["answerType"]),
    );
  }

  void update(dynamic response) {
    answerType = answerTypeFromResponse(response);
    answer = answerType == AnswerType.text
        ? response["text"]
        : (response["images"] as List).map((r) => base64Decode(r)).toList();
    return;
  }
}
