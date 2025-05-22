// lib/screens/home_screen.dart
import 'package:app/screens/anime/all_anime_screen.dart';
import 'package:app/screens/manga/all_manga_screen.dart';
import 'package:flutter/material.dart';
import '../models/anime/anime.dart';
import '../models/manga/manga.dart';
import '../widgets/cards_anime/anime_card.dart';
import '../widgets/cards_manga/manga_card.dart';
import '../colors/app_colors.dart';
import '../screens/anime/anime_detail_screen.dart';
import '../screens/manga/manga_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Anime> animes;
  final List<Manga> mangas;

  const HomeScreen({Key? key, required this.animes, required this.mangas})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort and take top 10 for display
    final top10Animes =
        List<Anime>.from(animes)
          ..sort((a, b) => a.rank.compareTo(b.rank))
          ..take(10).toList();

    final top10Mangas =
        List<Manga>.from(mangas)
          ..sort((a, b) => a.rank.compareTo(b.rank))
          ..take(10).toList();

    return Scaffold(
      backgroundColor: AppColors.cor1,
      appBar: AppBar(
        backgroundColor: AppColors.cor4,
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
                  _buttonSection("Ver mais", isAnime: true, context: context),
                ],
              ),
              const SizedBox(height: 12),
              _buildHorizontalList(top10Animes, isAnime: true),
              const SizedBox(height: 32),
              Row(
                children: [
                  _sectionTitle("Top 10 Mangás"),
                  const Spacer(),
                  _buttonSection("Ver mais", isAnime: false, context: context),
                ],
              ),
              const SizedBox(height: 12),
              _buildHorizontalList(top10Mangas, isAnime: false),
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

  Widget _buttonSection(
    String title, {
    required bool isAnime,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        if (isAnime) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllAnimeScreen(initialAnimes: animes),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              // Corrigido aqui
              builder: (context) => AllMangaScreen(initialMangas: mangas),
            ),
          );
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List<dynamic> lista, {required bool isAnime}) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lista.length,
        itemBuilder: (context, index) {
          final item = lista[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            isAnime
                                ? AnimeDetailScreen(anime: item as Anime)
                                : MangaDetailScreen(manga: item as Manga),
                  ),
                );
              },
              child: SizedBox(
                width: 130,
                child:
                    isAnime
                        ? AnimeCard(anime: item as Anime, showRank: true)
                        : MangaCard(manga: item as Manga, showRank: true),
              ),
            ),
          );
        },
      ),
    );
  }
}
