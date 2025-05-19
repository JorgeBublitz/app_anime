import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/anime/anime.dart';
import 'models/manga/manga.dart';
import 'models/anime/animePerson.dart';
import 'models/manga/mangaPerson.dart';
import 'models/voices/voice.dart';
import 'models/character.dart';

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

  // Método genérico para buscar um único item
  static Future<Map<String, dynamic>> _getSingleData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/$endpoint"));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['data'];
      }
      throw Exception("Erro ${response.statusCode}: ${response.reasonPhrase}");
    } catch (e) {
      throw Exception("Erro de conexão: $e");
    }
  }

  // Métodos para Top Animes
  static Future<List<Anime>> topAnimes({int limit = 10}) async {
    final data = await _getListData("top/anime?limit=$limit");
    return data.map((json) => Anime.fromJson(json)).toList();
  }

  // Métodos para Top Mangás
  static Future<List<Manga>> topMangas({int limit = 10}) async {
    final data = await _getListData("top/manga?limit=$limit");
    return data.map((json) => Manga.fromJson(json)).toList();
  }

  // Métodos para buscar animes e mangás
  static Future<List<Anime>> buscarAnimes() async {
    final data = await _getListData("anime");
    return data.map((json) => Anime.fromJson(json)).toList();
  }

  static Future<List<Manga>> buscarMangas() async {
    final data = await _getListData("manga");
    return data.map((json) => Manga.fromJson(json)).toList();
  }

  // Métodos para detalhes de anime e mangá
  static Future<Anime> detalhesAnime(int animeId) async {
    final data = await _getSingleData("anime/$animeId/full");
    return Anime.fromJson(data);
  }

  static Future<Manga> detalhesManga(int mangaId) async {
    final data = await _getSingleData("manga/$mangaId/full");
    return Manga.fromJson(data);
  }

  // Método para buscar detalhes de um personagem específico
  static Future<Character> detalhesPersonagem(int characterId) async {
    final data = await _getSingleData("characters/$characterId");
    return Character.fromJson(data);
  }

  // Métodos para Personagens
  static Future<List<AnimePerson>> buscarPersonagens(int animeId) async {
    final data = await _getListData("anime/$animeId/characters");
    return data
        .map((json) => AnimePerson.fromJson(json))
        .where((p) => p.role == "Main")
        .toList();
  }

  static Future<List<AnimePerson>> buscarTodosPersonagens(int animeId) async {
    final data = await _getListData("anime/$animeId/characters");
    return data.map((json) => AnimePerson.fromJson(json)).toList();
  }

  static Future<List<MangaPerson>> buscarPersonagensM(int mangaId) async {
    final data = await _getListData("manga/$mangaId/characters");
    return data.map((json) => MangaPerson.fromJson(json)).toList();
  }

  // Método para buscar dubladores por idioma
  static Future<List<Voice>> buscarVoiceActors(int characterId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/characters/$characterId/voices"),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return (jsonData['data'] as List)
            .map((json) => Voice.fromJson(json))
            .toList();
      }
      throw Exception("Erro ao buscar dubladores: ${response.statusCode}");
    } catch (e) {
      throw Exception("Erro de conexão ao buscar dubladores: $e");
    }
  }

  // Método para buscar dubladores por idioma específico
  static Future<List<Voice>> buscarDubladoresPorIdioma(
    int characterId,
    String idioma,
  ) async {
    final voices = await buscarVoiceActors(characterId);
    return voices
        .where(
          (voice) =>
              voice.language.toLowerCase().contains(idioma.toLowerCase()),
        )
        .toList();
  }
}
