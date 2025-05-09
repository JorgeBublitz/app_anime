// animePerson.dart
class MangaPerson {
  final String nome;
  final String imagemUrl;
  final String funcao;

  MangaPerson({
    required this.nome,
    required this.imagemUrl,
    required this.funcao,
  });

  factory MangaPerson.fromJson(Map<String, dynamic> json) {
    return MangaPerson(
      nome: json['character']?['name'] ?? '',
      imagemUrl: json['character']?['images']?['jpg']?['image_url'] ?? '',
      funcao: json['role'] ?? '',
    );
  }
}
