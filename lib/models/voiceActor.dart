import 'person.dart';

class VoiceActor {
  final Person person;
  final String language;

  VoiceActor({required this.person, required this.language});

  factory VoiceActor.fromJson(Map<String, dynamic> json) {
    return VoiceActor(
      person: Person.fromJson(json['person'] as Map<String, dynamic>),
      language: json['language'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'person': person.toJson(),
    'language': language,
  };
}
