// animePerson.dart
class AnimePerson {
  final String nome;
  final String imagemUrl;
  final String funcao;

  AnimePerson({
    required this.nome,
    required this.imagemUrl,
    required this.funcao,
  });

  factory AnimePerson.fromJson(Map<String, dynamic> json) {
    return AnimePerson(
      nome: json['character']?['name'] ?? '',
      imagemUrl: json['character']?['images']?['jpg']?['image_url'] ?? '',
      funcao: json['role'] ?? '',
    );
  }
}
