import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/animePerson.dart';
import 'models/mangaPerson.dart';
import 'models/voice.dart';

class ApiService {
  static const _baseUrl = "https://api.jikan.moe/v4";

  // Método genérico para buscar dados
  static Future<List<Map<String, dynamic>>> _getListData(
    String endpoint,
  ) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/$endpoint"));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['data']);
      }
      throw Exception("Erro ${response.statusCode}: ${response.reasonPhrase}");
    } catch (e) {
      throw Exception("Erro de conexão: $e");
    }
  }

  // Métodos para Animes
  static Future<List<Map<String, dynamic>>> buscarAnimes() =>
      _getListData("anime");
  static Future<List<Map<String, dynamic>>> topAnimes() =>
      _getListData("top/anime?limit=10");

  // Métodos para Mangás
  static Future<List<Map<String, dynamic>>> buscarMangas() =>
      _getListData("manga");
  static Future<List<Map<String, dynamic>>> topMangas() =>
      _getListData("top/manga?limit=10");

  // Métodos para Personagens
  static Future<List<AnimePerson>> buscarPersonagens(int animeId) async {
    final data = await _getListData("anime/$animeId/characters");
    return data
        .map((json) => AnimePerson.fromJson(json))
        .where((p) => p.funcao.toLowerCase().contains('main'))
        .toList();
  }

  static Future<List<Voice>> buscarVoiceActors(int characterId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/characters/$characterId/voices"),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData['data'] as List)
          .map((json) => Voice.fromJson(json))
          .toList();
    }
    throw Exception("Failed to load voice actors");
  }

  static Future<List<AnimePerson>> buscarTodosPersonagens(int animeId) async {
    final data = await _getListData("anime/$animeId/characters");
    return data.map((json) => AnimePerson.fromJson(json)).toList();
  }

  static Future<List<MangaPerson>> buscarPersonagensM(int mangaId) async {
    final data = await _getListData("manga/$mangaId/characters");
    return data.map((json) => MangaPerson.fromJson(json)).toList();
  }
}
