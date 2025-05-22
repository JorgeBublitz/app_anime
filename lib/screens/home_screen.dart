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
import '../widgets/feature_carousel.dart';
import '../widgets/category_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final List<Anime> animes;
  final List<Manga> mangas;

  const HomeScreen({super.key, required this.animes, required this.mangas});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late List<Anime> _filteredAnimes;
  late List<Manga> _filteredMangas;
  late List<Anime> _featuredAnimes;
  late List<Anime> _actionAnimes;
  late List<Manga> _popularMangas;
  bool _isAdultContentEnabled = false;
  bool _isLoading = true;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPreferences();
    _initializeData();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdultContentEnabled = prefs.getBool('adultContentEnabled') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adultContentEnabled', _isAdultContentEnabled);
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Filtrar animes e mangás com base na configuração de conteúdo adulto
      _filteredAnimes = _filterContent(widget.animes);
      _filteredMangas = _filterContent(widget.mangas);

      // Obter animes em destaque (top 5 por popularidade)
      _featuredAnimes =
          List<Anime>.from(_filteredAnimes)
            ..sort((a, b) => a.popularity.compareTo(b.popularity))
            ..take(5).toList();

      // Obter animes de ação
      _actionAnimes =
          _filteredAnimes
              .where(
                (anime) => anime.genres.any(
                  (genre) => genre.name.toLowerCase().contains('action'),
                ),
              )
              .take(10)
              .toList();

      // Obter mangás populares
      _popularMangas =
          List<Manga>.from(_filteredMangas)
            ..sort((a, b) => a.popularity.compareTo(b.popularity))
            ..take(10).toList();
    } catch (e) {
      print('Erro ao inicializar dados: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<T> _filterContent<T>(List<T> items) {
    if (_isAdultContentEnabled) {
      return items;
    } else {
      if (T == Anime) {
        return items
            .where(
              (item) =>
                  (item as Anime).rating != 'R+ - Mild Nudity' &&
                  (item as Anime).rating != 'Rx - Hentai',
            )
            .toList();
      } else if (T == Manga) {
        return items;
      }
      return items;
    }
  }

  void _toggleAdultContent() {
    setState(() {
      _isAdultContentEnabled = !_isAdultContentEnabled;
      _savePreferences();
      _initializeData();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (!_isSearchExpanded) {
        _searchController.clear();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cor1,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingIndicator() : _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.cor4,
      elevation: 4,
      title:
          _isSearchExpanded
              ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Buscar anime, mangá...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  // Implementar busca
                  _toggleSearch();
                },
                autofocus: true,
              )
              : const Text(
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
          icon: Icon(
            _isSearchExpanded ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          tooltip: _isSearchExpanded ? "Fechar" : "Buscar",
          onPressed: _toggleSearch,
        ),
        IconButton(
          icon: Icon(
            _isAdultContentEnabled ? Icons.no_adult_content : Icons.shield,
            color: _isAdultContentEnabled ? Colors.red : Colors.green,
          ),
          tooltip:
              _isAdultContentEnabled
                  ? "Desativar conteúdo adulto"
                  : "Ativar conteúdo adulto",
          onPressed: _toggleAdultContent,
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white, // cor do texto quando selecionado
        unselectedLabelColor:
            Colors.grey, // cor do texto quando não selecionado
        tabs: const [Tab(text: 'Mangas'), Tab(text: 'Animes')],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.cor4),
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [_buildAnimeTab(), _buildMangaTab()],
    );
  }

  Widget _buildAnimeTab() {
    return RefreshIndicator(
      onRefresh: _initializeData,
      color: AppColors.cor4,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner de destaque
              FeatureCarousel(animes: _featuredAnimes),

              const SizedBox(height: 24),

              // Seção Top 10 Animes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _sectionTitle("Top 10 Animes"),
                    const Spacer(),
                    _buttonSection("Ver mais", isAnime: true),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildHorizontalList(
                _filteredAnimes
                  ..sort((a, b) => a.rank.compareTo(b.rank))
                  ..take(10).toList(),
                isAnime: true,
              ),

              const SizedBox(height: 24),

              // Seção Animes de Ação
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionTitle("Animes de Ação"),
              ),
              const SizedBox(height: 12),
              _buildHorizontalList(_actionAnimes, isAnime: true),

              const SizedBox(height: 24),

              // Seção Lançamentos da Temporada
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionTitle("Lançamentos da Temporada"),
              ),
              const SizedBox(height: 12),
              CategorySection(
                items:
                    _filteredAnimes
                        .where((anime) => anime.status == "Currently Airing")
                        .take(6)
                        .toList(),
                isAnime: true,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMangaTab() {
    return RefreshIndicator(
      onRefresh: _initializeData,
      color: AppColors.cor4,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção Top 10 Mangás
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _sectionTitle("Top 10 Mangás"),
                    const Spacer(),
                    _buttonSection("Ver mais", isAnime: false),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildHorizontalList(
                _filteredMangas
                  ..sort((a, b) => a.rank.compareTo(b.rank))
                  ..take(10).toList(),
                isAnime: false,
              ),

              const SizedBox(height: 24),

              // Seção Mangás Populares
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionTitle("Mangás Populares"),
              ),
              const SizedBox(height: 12),
              _buildHorizontalList(_popularMangas, isAnime: false),

              const SizedBox(height: 24),

              // Seção Em Publicação
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionTitle("Em Publicação"),
              ),
              const SizedBox(height: 12),
              CategorySection(
                items:
                    _filteredMangas
                        .where((manga) => manga.publishing)
                        .take(6)
                        .toList(),
                isAnime: false,
              ),

              const SizedBox(height: 16),
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
        if (isAnime) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AllAnimeScreen(initialAnimes: _filteredAnimes),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AllMangaScreen(initialMangas: _filteredMangas),
            ),
          );
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<dynamic> lista, {required bool isAnime}) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lista.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final item = lista[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
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
                width: 140,
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.cor4,
      child: const Icon(Icons.filter_list),
      onPressed: () {
        _showFilterDialog();
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cor1,
            title: const Text("Filtros", style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text(
                    "Conteúdo Adulto",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    _isAdultContentEnabled
                        ? "Ativado - Todo conteúdo será exibido"
                        : "Desativado - Conteúdo adulto será filtrado",
                    style: TextStyle(
                      color: _isAdultContentEnabled ? Colors.red : Colors.green,
                      fontSize: 12,
                    ),
                  ),
                  value: _isAdultContentEnabled,
                  onChanged: (value) {
                    Navigator.pop(context);
                    _toggleAdultContent();
                  },
                  activeColor: Colors.red,
                  inactiveTrackColor: Colors.grey.shade700,
                ),
                const Divider(color: Colors.grey),
                // Aqui podem ser adicionados mais filtros no futuro
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Fechar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }
}
