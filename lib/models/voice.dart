class Voice {
  final String nome;
  final String language;
  final String imagemUrl;

  Voice({required this.nome, required this.language, required this.imagemUrl});

  factory Voice.fromJson(Map<String, dynamic> json) {
    return Voice(
      nome: json['person']['name'], // Access 'person' object for voice actor details
      language: json['language'],
      imagemUrl: json['person']['images']['jpg']['image_url'] ?? '',
    );
  }
}