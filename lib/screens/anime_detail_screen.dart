// anime_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/anime.dart';
import '../../models/animePerson.dart';
import '../../colors/app_colors.dart';
import '../widgets/anime_person_card.dart';
import '../../api_service.dart';

class AnimeDetailScreen extends StatefulWidget {
  final Anime anime;

  const AnimeDetailScreen({Key? key, required this.anime}) : super(key: key);

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  bool _descricaoExpandida = false;
  late Future<List<AnimePerson>> _futureCharacters;

  @override
  void initState() {
    super.initState();
    _futureCharacters = buscarPersonagens(int.parse(widget.anime.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cor1,
      appBar: AppBar(
        title: Text(widget.anime.nome, overflow: TextOverflow.ellipsis),
        backgroundColor: AppColors.cor2,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEM + INFO
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagemAnime(),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoAnime()),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),

            // DESCRIÇÃO
            _buildDescricao(),

            const SizedBox(height: 24),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),

            // PERSONAGENS
            const Text(
              "Personagens",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildCharacterList(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagemAnime() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.anime.imagemUrl,
            width: 150,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  widget.anime.nota,
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
    );
  }

  Widget _buildInfoAnime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "#${widget.anime.rank}. ${widget.anime.nome}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 12),
        _infoText("Tipo", widget.anime.tipo),
        _infoText("Status", widget.anime.status),
        _infoText("Episódios", widget.anime.episodios),
        _infoText("Popularidade", widget.anime.popularidade),
      ],
    );
  }

  Widget _buildDescricao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          widget.anime.descricao,
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
      ],
    );
  }

  Widget _buildCharacterList() {
    return SizedBox(
      height: 180,
      child: FutureBuilder<List<AnimePerson>>(
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
                child: AnimePersonCard(personAnime: personagem),
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
