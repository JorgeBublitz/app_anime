class Anime {
  final String id;
  final String nome;
  final String imagemUrl;
  final String nota;
  final String rank;
  final String descricao;
  final String episodios;
  final String tipo;
  final String popularidade;
  final String status;

  Anime({
    required this.id,
    required this.nome,
    required this.imagemUrl,
    required this.nota,
    required this.rank,
    required this.descricao,
    required this.episodios,
    required this.tipo,
    required this.popularidade,
    required this.status,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'].toString(),
      nome: json['title'] ?? '',
      imagemUrl: json['images']?['jpg']?['image_url'] ?? '',
      nota: json['score']?.toString() ?? '0',
      rank: json['rank']?.toString() ?? '-',
      descricao: json['synopsis'] ?? 'Sem sinopse',
      episodios: json['episodes']?.toString() ?? '-',
      tipo: json['type'] ?? '-',
      popularidade: json['popularity']?.toString() ?? '-',
      status: json['status'] ?? '-',
    );
  }
}
