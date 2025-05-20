import 'package:flutter/material.dart';
import '../../colors/app_colors.dart';
import '../models/manga/manga.dart';
import '../models/manga/manga_person.dart';
import '../widgets/manga_person_card.dart';
import '../api_service.dart';

class MangaDetailScreen extends StatefulWidget {
  final Manga manga;

  const MangaDetailScreen({super.key, required this.manga});

  @override
  State<MangaDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<MangaDetailScreen> {
  bool _descricaoExpandida = false;
  late Future<List<MangaPerson>> _futureCharacters;

  @override
  void initState() {
    super.initState();
    _futureCharacters = ApiService.buscarPersonagensM(widget.manga.malId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cor1,
      appBar: AppBar(
        title: Text(
          widget.manga.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        backgroundColor: AppColors.cor2,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEM E INFORMAÇÕES PRINCIPAIS
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.manga.images.jpg.imageUrl,
                        width: 150,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.manga.score.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#${widget.manga.rank}. ${widget.manga.title}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        widget.manga.author,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white60,
                        ),
                      ),

                      const SizedBox(height: 12),
                      _infoText("Tipo", widget.manga.type),
                      _infoText("Status", widget.manga.status),
                      _infoText("Volumes", widget.manga.volumes.toString()),
                      _infoText("Capítulos", widget.manga.chapters.toString()),
                      _infoText(
                        "Popularidade",
                        widget.manga.popularity.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),

            // DESCRIÇÃO
            const Text(
              "Descrição",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.manga.synopsis ?? 'Sem descrição disponível.',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
              maxLines: _descricaoExpandida ? null : 8,
              overflow:
                  _descricaoExpandida
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _descricaoExpandida = !_descricaoExpandida;
                });
              },
              child: Text(
                _descricaoExpandida ? "Ler menos" : "Ler mais",
                style: const TextStyle(color: Colors.amber),
              ),
            ),
            const SizedBox(height: 8),
            _buildCharacterList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterList() {
    return SizedBox(
      height: 180,
      child: FutureBuilder<List<MangaPerson>>(
        future: _futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: \${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum personagem encontrado'));
          }
          final allChars = snapshot.data!;
          final mains =
              allChars.where((c) => c.funcao.toLowerCase() == 'main').toList();
          final others =
              allChars.where((c) => c.funcao.toLowerCase() != 'main').toList();
          final displayList = [...mains, ...others].take(10).toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final personagem = displayList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: MangaPersonCard(personManga: personagem),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 16, color: Colors.white70),
      ),
    );
  }
}
