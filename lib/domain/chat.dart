import 'dart:collection';

class Chat {
  final String id;
  final String question;
  String? answer;
  final DateTime date;

  Chat({
    required this.id,
    this.answer,
    required this.date,
    required this.question,
  });

  factory Chat.fromJson(LinkedHashMap<dynamic, dynamic> json) {
    return Chat(
      id: json["id"],
      answer: json["answer"],
      date: json["date"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["date"])
          : DateTime.now(),
      question: json["question"],
    );
  }
}
