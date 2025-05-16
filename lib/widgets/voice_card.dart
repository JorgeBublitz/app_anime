import 'package:app/models/voice.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../colors/app_colors.dart';

class VoiceCard extends StatelessWidget {
  final Voice personAnime;
  final bool compactMode;
  final VoidCallback? onTap;

  const VoiceCard({
    super.key,
    required this.personAnime,
    this.compactMode = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cor3,
          borderRadius: BorderRadius.circular(8),
        ),
        width: compactMode ? 120 : 130,
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
