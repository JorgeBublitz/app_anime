import 'image.dart';

class Character {
  final int malId;
  final String url;
  final Images images;
  final String name;
  final String? kanjiName;
  final String? bio;
  final int? favorite;
  final List<String>? nicknames;

  Character({
    required this.malId,
    required this.url,
    required this.images,
    required this.name,
    required this.kanjiName,
    this.bio,
    this.favorite,
    required this.nicknames,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      malId: json['mal_id'] ?? 0,
      url: json['url'] ?? '',
      images: Images.fromJson(json['images'] ?? {}),
      name: json['name'] ?? '',
      kanjiName: json['name_kanji'] ?? '',
      bio: json['about'] ?? '',
      favorite: json['favorites'] ?? 0,
      nicknames: List<String>.from(json['nicknames'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'url': url,
      'images': images.toJson(),
      'name': name,
      'name_kanji': kanjiName,
      'about': bio,
      'favorites': favorite,
      'nicknames': nicknames,
    };
  }
}
