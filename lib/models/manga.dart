class Manga {
  final String id;
  final String nome;
  final String imagemUrl;
  final String nota;
  final String rank;
  final String? autor;
  final String? sinopse;
  final String? status;
  final String? tipo;
  final String? volumes;
  final String? capitulos;
  final String? popularidade;

  Manga({
    required this.id,
    required this.nome,
    required this.imagemUrl,
    required this.nota,
    required this.rank,
    this.autor,
    this.sinopse,
    this.status,
    this.tipo,
    this.volumes,
    this.capitulos,
    this.popularidade,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['mal_id'].toString(),
      nome: json['title'] ?? 'Sem título',
      imagemUrl: json['images']?['jpg']?['image_url'] ?? '',
      nota: (json['score'] != null) ? json['score'].toString() : '0.0',
      rank: (json['rank'] != null) ? json['rank'].toString() : '-',
      sinopse: json['synopsis'] ?? 'Sem descrição disponível.',
      status: json['status'],
      tipo: json['type'],
      volumes: (json['volumes'] != null) ? json['volumes'].toString() : "Vazio",
      capitulos:
          (json['chapters'] != null) ? json['chapters'].toString() : "Vazio",
      popularidade:
          (json['members'] != null) ? json['members'].toString() : null,
      autor: json['authors']?[0]?['name'],
    );
  }
}
