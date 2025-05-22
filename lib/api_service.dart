import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/anime/anime.dart';
import 'models/manga/manga.dart';
import 'models/anime/anime_person.dart';
import 'models/manga/manga_person.dart';
import 'models/dublagem/voice.dart';
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

  static Future<Map<String, dynamic>> fetchAnimes({
    required int page,
    int limit = 24,
    String query = '',
    bool sfw = true,
  }) async {
    // Corrigindo a URL para incluir o endpoint /anime
    final url = Uri.parse(
      '$_baseUrl/anime?page=$page&limit=$limit&q=${Uri.encodeQueryComponent(query)}&sfw=$sfw',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final pagination = data['pagination'];
      final items = data['data'] as List;
      final animes = items.map((e) => Anime.fromJson(e)).toList();

      return {
        'animes': animes,
        'totalPages': pagination['last_visible_page'] ?? 1,
      };
    } else {
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> fetchMangas({
    required int page,
    int limit = 24,
    String query = '',
    bool sfw = true,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/manga?page=$page&limit=$limit&q=${Uri.encodeQueryComponent(query)}&sfw=$sfw',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final pagination = data['pagination'];
      final items = data['data'] as List;

      // Corrigido para Manga
      final mangas = items.map((e) => Manga.fromJson(e)).toList();

      return {
        'mangas': mangas, // Chave corrigida
        'totalPages': pagination['last_visible_page'] ?? 1,
      };
    } else {
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
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

  static Future<List<MangaPerson>> buscarTodosPersonagensM(int mangaId) async {
    final data = await _getListData("manga/$mangaId/characters");
    return data.map((json) => MangaPerson.fromJson(json)).toList();
  }

  static Future<List<MangaPerson>> buscarPersonagensM(int mangaId) async {
    final data = await _getListData("manga/$mangaId/characters");
    return data
        .map((json) => MangaPerson.fromJson(json))
        .where((p) => p.role == "Main")
        .toList();
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

  static Future<List<Map<String, dynamic>>> buscarTudo(String termo) async {
    final resultados = <Map<String, dynamic>>[];

    final responseAnime = await http.get(
      Uri.parse('https://api.jikan.moe/v4/anime?q=$termo'),
    );
    final responseManga = await http.get(
      Uri.parse('https://api.jikan.moe/v4/manga?q=$termo'),
    );
    final responsePersonagem = await http.get(
      Uri.parse('https://api.jikan.moe/v4/characters?q=$termo'),
    );

    if (responseAnime.statusCode == 200) {
      final json = jsonDecode(responseAnime.body);
      for (var item in json['data']) {
        resultados.add({"tipo": "anime", "item": Anime.fromJson(item)});
      }
    }

    if (responseManga.statusCode == 200) {
      final json = jsonDecode(responseManga.body);
      for (var item in json['data']) {
        resultados.add({"tipo": "manga", "item": Manga.fromJson(item)});
      }
    }

    if (responsePersonagem.statusCode == 200) {
      final json = jsonDecode(responsePersonagem.body);
      for (var item in json['data']) {
        resultados.add({"tipo": "personagem", "item": item});
      }
    }

    return resultados;
  }
}
