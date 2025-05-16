import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/anime/animePerson.dart';
import '../../colors/app_colors.dart';
import '../../screens/anime_person_detail_screen.dart';

class AnimePersonCard extends StatelessWidget {
  final AnimePerson personAnime;
  final bool compactMode;
  final VoidCallback? onTap;

  const AnimePersonCard({
    super.key,
    required this.personAnime,
    this.compactMode = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AnimePersonDetailScreen(animePerson: personAnime),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cor3,
          borderRadius: BorderRadius.circular(8),
        ),
        width: compactMode ? 100 : 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildImage(), _buildName()],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: CachedNetworkImage(
        imageUrl: personAnime.imagemUrl,
        width: double.infinity,
        height: compactMode ? 100 : 135,
        fit: BoxFit.cover,
        progressIndicatorBuilder:
            (_, __, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progress,
                color: AppColors.cor3,
              ),
            ),
        errorWidget:
            (_, __, ___) => Container(
              color: AppColors.cor2,
              child: const Icon(
                Icons.person_off_outlined,
                color: Colors.white54,
                size: 40,
              ),
            ),
      ),
    );
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.all(6).copyWith(top: 8),
      child: Text(
        personAnime.nome,
        maxLines: compactMode ? 1 : 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: compactMode ? 12 : 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
