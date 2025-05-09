// anime_person_card.dart
import 'package:flutter/material.dart';
import '../models/animePerson.dart';
import '../colors/app_colors.dart';

class AnimePersonCard extends StatelessWidget {
  final AnimePerson personAnime;

  const AnimePersonCard({Key? key, required this.personAnime})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cor2,
          borderRadius: BorderRadius.circular(8),
        ),
        width: 120,
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: Image.network(
                personAnime.imagemUrl,
                width: double.infinity,
                height: 135,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    personAnime.nome,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
