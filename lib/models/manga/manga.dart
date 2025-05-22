import '../image.dart';
import 'genre_manga.dart';

class Manga {
  final int? malId;
  final String url;
  final Images images;
  final List<GenreManga> genres;
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
    required this.genres,
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
      malId: json['mal_id'] as int?,
      url: json['url'] as String,
      images: Images.fromJson(json['images'] as Map<String, dynamic>),
      title: json['title'] as String,
      author: _parseAuthor(json['author']),
      genres:
          (json['genres'] as List)
              .map((g) => GenreManga.fromJson(g as Map<String, dynamic>))
              .toList(),
      titleEnglish: json['title_english'] as String?,
      titleJapanese: json['title_japanese'] as String?,
      titleSynonyms: (json['title_synonyms'] as List).cast<String>(),
      type: json['type'] as String,
      chapters: json['chapters'] as int?,
      volumes: json['volumes'] as int?,
      status: json['status'] as String,
      publishing: json['publishing'] as bool,
      score: json['score'] as double,
      scoredBy: json['scored_by'] as int,
      rank: json['rank'] as int,
      popularity: json['popularity'] as int,
      members: json['members'] as int,
      favorites: json['favorites'] as int,
      synopsis: json['synopsis'] as String?,
      background: json['background'] as String?,
    );
  }

  static String _parseAuthor(dynamic authorData) {
    if (authorData is String) return authorData;
    if (authorData is List) {
      return authorData
          .whereType<Map<String, dynamic>>()
          .map<String>((a) => a['name'] as String? ?? '')
          .join(', ');
    }
    return 'Autor desconhecido';
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
      'genres': genres.map((g) => g.toJson()).toList(),
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
