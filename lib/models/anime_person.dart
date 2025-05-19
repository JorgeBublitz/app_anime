import 'character.dart';
import 'voiceActor.dart'; // import correto
// remova o import de 'voice.dart' se não estiver usando

class AnimePerson {
  final Character character;
  final String role;
  final int favorites;
  final List<VoiceActor> voiceActors; // agora é VoiceActor

  AnimePerson({
    required this.character,
    required this.role,
    required this.favorites,
    required this.voiceActors,
  });

  factory AnimePerson.fromJson(Map<String, dynamic> json) {
    return AnimePerson(
      character: Character.fromJson(json['character'] as Map<String, dynamic>),
      role: json['role'] as String? ?? '',
      favorites: json['favorites'] as int? ?? 0,
      voiceActors:
          (json['voice_actors'] as List<dynamic>? ?? [])
              .map((e) => VoiceActor.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'character': character.toJson(),
    'role': role,
    'favorites': favorites,
    'voice_actors': voiceActors.map((va) => va.toJson()).toList(),
  };
}
