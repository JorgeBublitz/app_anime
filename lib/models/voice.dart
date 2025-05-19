import 'person.dart';

class Voice {
  final String language;
  final Person person;

  Voice({required this.language, required this.person});

  factory Voice.fromJson(Map<String, dynamic> json) {
    return Voice(
      language: json['language'] ?? '',
      person: Person.fromJson(json['person'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'language': language, 'person': person.toJson()};
  }
}
