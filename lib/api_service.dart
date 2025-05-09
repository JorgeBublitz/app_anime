// lib/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> buscarAnimes() async {
  final url = Uri.parse("https://api.jikan.moe/v4/anime");
  final resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    final json = jsonDecode(resposta.body);
    return json["data"]; // Retorna apenas a lista de animes
  } else {
    throw Exception("Erro ao carregar os animes");
  }
}

Future<List<dynamic>> topAnimes() async {
  final url = Uri.parse(
    "https://api.jikan.moe/v4/top/anime?limit=10",
  ); // limit=10 para pegar apenas os 10 primeiros
  final resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    final json = jsonDecode(resposta.body);
    return json["data"]; // Retorna apenas a lista dos top 10 animes
  } else {
    throw Exception("Erro ao carregar os animes");
  }
}

Future<List<dynamic>> topMangas() async {
  final url = Uri.parse(
    "https://api.jikan.moe/v4/top/manga?limit=10",
  ); // limit=10 para pegar apenas os 10 primeiros
  final resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    final json = jsonDecode(resposta.body);
    return json["data"]; // Retorna apenas a lista dos top 10 animes
  } else {
    throw Exception("Erro ao carregar os animes");
  }
}
