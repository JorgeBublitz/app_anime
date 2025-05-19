// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/anime/anime.dart';
import '../models/manga/manga.dart';
import '../widgets/card/animeCard/anime_card.dart';
import '../widgets/card/mangaCard/manga_card.dart';
import '../colors/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final List<Anime> animes;
  final List<Manga> mangas;

  const HomeScreen({Key? key, required this.animes, required this.mangas})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ordena os animes e mangas pelo rank
    final sortedAnimes = List<Anime>.from(animes)
      ..sort((a, b) => a.rank.compareTo(b.rank));

    final sortedMangas = List<Manga>.from(mangas)
      ..sort((a, b) => a.rank.compareTo(b.rank));

    return Scaffold(
      backgroundColor: AppColors.cor1,
      appBar: AppBar(
        backgroundColor: AppColors.cor2,
        elevation: 4,
        title: const Text(
          "OtakuHub",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: "Buscar",
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _sectionTitle("Top 10 Animes"),
                  const Spacer(),
                  _buttonSection("Ver mais", isAnime: true),
                ],
              ),
              const SizedBox(height: 12),
              _buildHorizontalList(sortedAnimes, isAnime: true),
              const SizedBox(height: 32),
              Row(
                children: [
                  _sectionTitle("Top 10 Mangas"),
                  const Spacer(),
                  _buttonSection("Ver mais", isAnime: false),
                ],
              ),
              const SizedBox(height: 12),
              _buildHorizontalList(sortedMangas, isAnime: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buttonSection(String title, {required bool isAnime}) {
    return InkWell(
      onTap: () {
        // Navegar para outra tela
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List<dynamic> lista, {required bool isAnime}) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lista.length,
        itemBuilder: (context, index) {
          final item = lista[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: SizedBox(
              width: 120,
              child:
                  isAnime
                      ? AnimeCard(anime: item as Anime)
                      : MangaCard(manga: item as Manga),
            ),
          );
        },
      ),
    );
  }
}
