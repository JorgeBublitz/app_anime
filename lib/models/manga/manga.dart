import '../image.dart';

class Manga {
  final int malId;
  final String url;
  final Images images;
  final String title;
  final String author;
  final String? titleEnglish;
  final String? titleJapanese;
  final List<String> titleSynonyms;
  final String type;
  final int? chapters;
  final int? volumes;
  final String status;
  final bool publishing;
  final double score;
  final int scoredBy;
  final int rank;
  final int popularity;
  final int members;
  final int favorites;
  final String? synopsis;
  final String? background;

  Manga({
    required this.malId,
    required this.url,
    required this.images,
    required this.title,
    required this.author,
    this.titleEnglish,
    this.titleJapanese,
    required this.titleSynonyms,
    required this.type,
    this.chapters,
    this.volumes,
    required this.status,
    required this.publishing,
    required this.score,
    required this.scoredBy,
    required this.rank,
    required this.popularity,
    required this.members,
    required this.favorites,
    this.synopsis,
    this.background,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      malId: json['mal_id'] ?? 0,
      url: json['url'] ?? '',
      images: Images.fromJson(json['images'] ?? {}),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      titleEnglish: json['title_english'],
      titleJapanese: json['title_japanese'],
      titleSynonyms: List<String>.from(json['title_synonyms'] ?? []),
      type: json['type'] ?? '',
      chapters: json['chapters'],
      volumes: json['volumes'],
      status: json['status'] ?? '',
      publishing: json['publishing'] ?? false,
      score: (json['score'] ?? 0).toDouble(),
      scoredBy: json['scored_by'] ?? 0,
      rank: json['rank'] ?? 0,
      popularity: json['popularity'] ?? 0,
      members: json['members'] ?? 0,
      favorites: json['favorites'] ?? 0,
      synopsis: json['synopsis'],
      background: json['background'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'url': url,
      'images': images.toJson(),
      'title': title,
      'author': author,
      if (titleEnglish != null) 'title_english': titleEnglish,
      if (titleJapanese != null) 'title_japanese': titleJapanese,
      'title_synonyms': titleSynonyms,
      'type': type,
      if (chapters != null) 'chapters': chapters,
      if (volumes != null) 'volumes': volumes,
      'status': status,
      'publishing': publishing,
      'score': score,
      'scored_by': scoredBy,
      'rank': rank,
      'popularity': popularity,
      'members': members,
      'favorites': favorites,
      if (synopsis != null) 'synopsis': synopsis,
      if (background != null) 'background': background,
    };
  }
}
