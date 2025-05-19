import 'package:flutter/material.dart';
import '../../../models/anime/animePerson.dart';
import '../../../colors/app_colors.dart';
import '../../../screens/anime/anime_person_detail_screen.dart';

class AnimePersonCard extends StatelessWidget {
  final AnimePerson personAnime;
  final bool compactMode;
  final VoidCallback? onTap;

  const AnimePersonCard({
    Key? key,
    required this.personAnime,
    this.compactMode = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cardWidth = compactMode ? 100 : 140;
    return SizedBox(
      width: cardWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap:
              onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            AnimePersonDetailScreen(animePerson: personAnime),
                  ),
                );
              },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: personAnime.character.malId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          personAnime.character.images.jpg.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                        : null,
                              ),
                            );
                          },
                          errorBuilder:
                              (_, __, ___) => Container(
                                color: AppColors.cor1,
                                child: Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                              ),
                            ),
                            child: Text(
                              personAnime.character.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
