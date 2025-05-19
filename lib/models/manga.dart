import 'image.dart';

class Manga {
  final int malId;
  final String url;
  final Images images;
  final String title;
  final String author;
  final String? titleEnglish;
  final String? titleJapanese;
  final List<String> titleSynonyms;
  final String? synopsis;
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

  const Manga({
    required this.malId,
    required this.url,
    required this.images,
    required this.title,
    required this.author,
    this.titleEnglish,
    this.titleJapanese,
    this.titleSynonyms = const [],
    this.synopsis,
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
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      malId: json['mal_id'] as int,
      url: json['url'] as String,
      images: Images.fromJson(json['images'] as Map<String, dynamic>),
      title: json['title'] as String,
      author: json['author'] as String,
      titleEnglish: json['title_english'] as String?,
      titleJapanese: json['title_japanese'] as String?,
      titleSynonyms: List<String>.from(
        json['title_synonyms'] as List<dynamic>? ?? [],
      ),
      synopsis: json['synopsis'] as String?,
      type: json['type'] as String,
      chapters: json['chapters'] as int?,
      volumes: json['volumes'] as int?,
      status: json['status'] as String,
      publishing: json['publishing'] as bool,
      score: (json['score'] as num).toDouble(),
      scoredBy: json['scored_by'] as int,
      rank: json['rank'] as int,
      popularity: json['popularity'] as int,
      members: json['members'] as int,
      favorites: json['favorites'] as int,
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
      if (synopsis != null) 'synopsis': synopsis,
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
    };
  }

  @override
  String toString() {
    return 'Manga(malId: $malId, title: $title, type: $type, status: $status, score: $score)';
  }
}
