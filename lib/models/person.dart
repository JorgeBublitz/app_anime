import 'image.dart';

class Person {
  final int malId;
  final String url;
  final Images images;
  final String name;

  Person({
    required this.malId,
    required this.url,
    required this.images,
    required this.name,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      malId: json['mal_id'] as int? ?? 0,
      url: json['url'] as String? ?? '',
      images: Images.fromJson(json['images'] as Map<String, dynamic>? ?? {}),
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'mal_id': malId,
    'url': url,
    'images': images.toJson(),
    'name': name,
  };
}
