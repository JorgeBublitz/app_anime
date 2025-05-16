import 'package:flutter/material.dart';
import '../../models/manga/manga.dart';
import '../../colors/app_colors.dart';
import '../../screens/manga_detail_screen.dart';

class MangaCard extends StatelessWidget {
  final Manga manga;

  MangaCard({required this.manga});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaDetailScreen(manga: manga),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cor2,
          borderRadius: BorderRadius.circular(8), // Menor borderRadius
        ),
        width: 120, // Largura menor
        height: 180, // Altura menor
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                manga.imagemUrl,
                width: double.infinity,
                height: 90, // Menor altura para a imagem
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0), // Padding mais enxuto
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "#${manga.rank}. ",
                        style: TextStyle(
                          fontSize: 13, // Fonte menor
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          manga.nome,
                          style: TextStyle(
                            fontSize: 13, // Fonte menor
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4), // Menor espaçamento
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14, // Ícone menor
                      ),
                      SizedBox(width: 4),
                      Text(
                        manga.nota,
                        style: TextStyle(
                          fontSize: 14, // Fonte menor para a nota
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
