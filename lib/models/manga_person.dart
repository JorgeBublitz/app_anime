import 'character.dart';
import 'voice.dart';

class MangaPerson {
  final Character character;
  final String role;
  final int favorites;

  MangaPerson({
    required this.character,
    required this.role,
    required this.favorites,
  });

  factory MangaPerson.fromJson(Map<String, dynamic> json) {
    return MangaPerson(
      character: Character.fromJson(json['character'] ?? {}),
      role: json['role'] ?? '',
      favorites: json['favorites'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'character': character.toJson(),
      'role': role,
      'favorites': favorites,
    };
  }

  // Getter para obter a função do personagem (Main, Supporting, etc.)
  String get funcao => role;
}
