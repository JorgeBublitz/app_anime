class AnimePerson {
  final String nome;
  final String imagemUrl;
  final String funcao;
  final String? biografia;
  final String? nascimento;
  final String? idade;
  final String? genero;
  final String? favoritos;

  AnimePerson({
    required this.nome,
    required this.imagemUrl,
    required this.funcao,
    this.biografia,
    this.nascimento,
    this.idade,
    this.genero,
    this.favoritos,
  });

  factory AnimePerson.fromJson(Map<String, dynamic> json) {
    String? bioOriginal = json['character']?['about'];
    String? nascimento = _extrairNascimento(bioOriginal);
    String? idade = _extrairIdade(bioOriginal);
    String? biografiaLimpa = _limparBiografia(bioOriginal);

    return AnimePerson(
      nome: json['character']?['name'] ?? '',
      imagemUrl: json['character']?['images']?['jpg']?['image_url'] ?? '',
      funcao: json['role'] ?? '',
      biografia: biografiaLimpa,
      nascimento: nascimento,
      idade: idade,
      genero: json['character']?['gender'],
      favoritos: json['character']?['favorites']?.toString(),
    );
  }

  /// Extrai data de nascimento da biografia
  static String? _extrairNascimento(String? biografia) {
    if (biografia == null) return null;
    final regex = RegExp(
      r'(Born|Nascimento|Date of birth)[^\d]*(\d{1,2} \w+ \d{4}|\w+ \d{1,2},? \d{4}|\d{4})',
      caseSensitive: false,
    );
    final match = regex.firstMatch(biografia);
    return match != null ? match.group(2) : null;
  }

  /// Extrai idade da biografia
  static String? _extrairIdade(String? biografia) {
    if (biografia == null) return null;
    final regex = RegExp(
      r'(\b\d{1,3})\s*(years old|anos|anos de idade)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(biografia);
    return match != null ? match.group(1) : null;
  }

  /// Remove nascimento e idade da biografia
  static String? _limparBiografia(String? biografia) {
    if (biografia == null) return null;

    // Remove linhas com nascimento ou idade
    final linhas = biografia.split('\n');
    final linhasFiltradas =
        linhas.where((linha) {
          final lower = linha.toLowerCase();
          return !(lower.contains('born') ||
              lower.contains('nascimento') ||
              lower.contains('date of birth') ||
              lower.contains('years old') ||
              lower.contains('anos'));
        }).toList();

    return linhasFiltradas.join('\n').trim();
  }
}
