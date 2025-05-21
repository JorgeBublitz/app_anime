import 'package:flutter/material.dart';
import '/colors/app_colors.dart';
import '/widgets/anime_card.dart';
import '/models/anime/anime.dart';
import '/api_service.dart';

class AllAnimeScreen extends StatefulWidget {
  const AllAnimeScreen({Key? key}) : super(key: key);

  @override
  State<AllAnimeScreen> createState() => _AllAnimeScreenState();
}

class _AllAnimeScreenState extends State<AllAnimeScreen> {
  late Future<List<Anime>> _futuroAnimes;

  @override
  void initState() {
    super.initState();
    _futuroAnimes = ApiService.listarTodosAnimes(); // nova chamada aqui
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos os Animes")),
      body: FutureBuilder<List<Anime>>(
        future: _futuroAnimes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum anime encontrado"));
          }

          final animes = snapshot.data!;
          return ListView.builder(
            itemCount: animes.length,
            itemBuilder: (context, index) {
              final anime = animes[index];
              return ListTile(
                title: Text(anime.titulo),
                subtitle: Text(anime.genero),
              );
            },
          );
        },
      ),
    );
  }
}
