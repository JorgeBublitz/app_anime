class Voice {
  final String language;
  final String name;

  Voice({required this.language, required this.name});

  factory Voice.fromJson(Map<String, dynamic> json) {
    return Voice(language: json['language'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'language': language, 'name': name};
}
