class Manga {
  final String nome;
  final String imagemUrl;
  final String nota;
  final String rank;

  Manga({
    required this.nome,
    required this.imagemUrl,
    required this.nota,
    required this.rank,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      nome: json['title'] ?? '',
      imagemUrl: json['images']?['jpg']?['image_url'] ?? '',
      nota: json['score']?.toString() ?? '0',
      rank: json['rank']?.toString() ?? '-',
    );
  }
}
