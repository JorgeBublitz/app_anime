class GenreAnime {
  final int malId;
  final String name;

  GenreAnime({required this.malId, required this.name});

  factory GenreAnime.fromJson(Map<String, dynamic> json) {
    return GenreAnime(
      malId: json['mal_id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
