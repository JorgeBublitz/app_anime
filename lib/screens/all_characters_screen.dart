import 'package:flutter/material.dart';
import '../models/anime/anime_person.dart';
import '../widgets/anime_person_card.dart';
import '../colors/app_colors.dart';

class AllCharactersScreen extends StatefulWidget {
  final List<AnimePerson> listaPersonagens;

  const AllCharactersScreen({Key? key, required this.listaPersonagens})
    : super(key: key);

  @override
  _AllCharactersScreenState createState() => _AllCharactersScreenState();
}

class _AllCharactersScreenState extends State<AllCharactersScreen> {
  String _query = '';

  List<AnimePerson> get _filteredList {
    if (_query.isEmpty) return widget.listaPersonagens;
    return widget.listaPersonagens
        .where(
          (p) => p.character.name.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cor1,
      appBar: AppBar(
        title: const Text('Personagens'),
        backgroundColor: AppColors.cor2,
        centerTitle: true,
        elevation: 1,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  filled: true,
                  fillColor: AppColors.cor2,
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child:
                  _filteredList.isEmpty
                      ? const Center(
                        child: Text(
                          'Nenhum personagem encontrado.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                      : Padding(
                        padding: EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: MediaQuery.of(context).padding.bottom + 12,
                        ),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          cacheExtent: 500,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.7,
                              ),
                          itemCount: _filteredList.length,
                          itemBuilder: (context, index) {
                            final person = _filteredList[index];
                            return AnimePersonCard(
                              personAnime: person,
                              compactMode: false,
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
