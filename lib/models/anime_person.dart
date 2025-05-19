import 'character.dart';
import 'voice.dart';

class AnimePerson {
  final Character character;
  final String role;
  final int favorites;
  final List<Voice> voiceActors;

  AnimePerson({
    required this.character,
    required this.role,
    required this.favorites,
    required this.voiceActors,
  });

  factory AnimePerson.fromJson(Map<String, dynamic> json) {
    return AnimePerson(
      character: Character.fromJson(json['character'] ?? {}),
      role: json['role'] ?? '',
      favorites: json['favorites'] ?? 0,
      voiceActors:
          (json['voice_actors'] as List? ?? [])
              .map((voice) => Voice.fromJson(voice))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'character': character.toJson(),
      'role': role,
      'favorites': favorites,
      'voice_actors': voiceActors.map((voice) => voice.toJson()).toList(),
    };
  }

  // Getter para obter a função do personagem (Main, Supporting, etc.)
  String get funcao => role;
}
