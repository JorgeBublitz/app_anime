import 'package:flutter/material.dart';
import '../models/animePerson.dart';
import '../widgets/anime_person_card.dart';
import '../colors/app_colors.dart';

class AllCharactersScreen extends StatefulWidget {
  final List<AnimePerson> listaPersonagens;
  final bool is3xNLayout;

  const AllCharactersScreen({
    super.key,
    required this.listaPersonagens,
    this.is3xNLayout = false,
  });

  @override
  State<AllCharactersScreen> createState() => _AllCharactersScreenState();
}

class _AllCharactersScreenState extends State<AllCharactersScreen> {
  late TextEditingController _searchController;
  List<AnimePerson> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredList = widget.listaPersonagens;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCharacters(String query) {
    setState(() {
      _filteredList =
          widget.listaPersonagens.where((person) {
            return person.nome.toLowerCase().contains(query.toLowerCase());
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cor1,
      appBar: AppBar(
        title: const Text("Todos os Personagens"),
        backgroundColor: AppColors.cor2,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCharacters,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                hintText: 'Pesquisar personagem...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.amber),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child:
                _filteredList.isEmpty
                    ? const Center(
                      child: Text(
                        "Nenhum personagem encontrado.",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _calculateColumnCount(context),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.65,
                          mainAxisExtent: 140,
                        ),
                        itemCount: _filteredList.length,
                        itemBuilder:
                            (context, index) => AnimePersonCard(
                              personAnime: _filteredList[index],
                              compactMode: !widget.is3xNLayout,
                            ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  int _calculateColumnCount(BuildContext context) {
    if (widget.is3xNLayout) {
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth > 800) return 3;
      if (screenWidth > 600) return 3;
      if (screenWidth > 300) return 2;
      return 1;
    }
    return 3;
  }
}
