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
  final String? ano;
  final String? temporada;
  final String? estudio;
  final String? duracao;
  final String? classificacao;
  final List<String>? generos;

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
    this.ano,
    this.temporada,
    this.estudio,
    this.duracao,
    this.classificacao,
    this.generos,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'].toString(),
      nome: json['title'] ?? 'Sem título',
      imagemUrl: json['images']?['jpg']?['image_url'] ?? '',
      nota: json['score']?.toString() ?? '0',
      rank: json['rank']?.toString() ?? '-',
      descricao: json['synopsis'] ?? 'Sem sinopse',
      episodios: json['episodes']?.toString() ?? '-',
      tipo: json['type'] ?? '-',
      popularidade: json['popularity']?.toString() ?? '-',
      status: json['status'] ?? '-',
      ano: json['year']?.toString(),
      temporada: json['season'],
      estudio: json['studios'] != null ? json['studios'][0]['name'] : '',
      duracao: json['duration'],
      classificacao: json['rating'],
      generos:
          (json['genres'] as List?)
              ?.map((g) => g['name']?.toString() ?? '')
              .where((name) => name.isNotEmpty)
              .toList(),
    );
  }
}

String traduzirStatus(String statusOriginal) {
  switch (statusOriginal.toLowerCase()) {
    case 'finished airing':
      return 'Finalizado';
    case 'currently airing':
      return 'Atualmente em exibição';
    case 'not yet aired':
      return 'Ainda não lançado';
    default:
      return statusOriginal;
  }
}
String traduzirTipo(String tipoOriginal) {
  switch (tipoOriginal.toLowerCase()) {
    case 'tv':
      return 'Anime';
    case 'movie':
      return 'Filme';
    case 'ova':
      return 'OVA';
    case 'ona':
      return 'ONA';
    case 'special':
      return 'Especial';
    case 'music':
      return 'Clipe musical';
    default:
      return tipoOriginal;
  }
}
