import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/animePerson.dart';
import '../../colors/app_colors.dart';
import '../../screens/all_characters_screen.dart';
import '../widgets/anime_person_card.dart';
import '../widgets/voice_card.dart';
import 'package:app/models/voice.dart';
import '../api_service.dart';

class AnimePersonDetailScreen extends StatefulWidget {
  final AnimePerson animePerson;
  const AnimePersonDetailScreen({super.key, required this.animePerson});

  @override
  State<AnimePersonDetailScreen> createState() =>
      _AnimePersonDetailScreenState();
}

class _AnimePersonDetailScreenState extends State<AnimePersonDetailScreen> {
  bool _expandedDesc = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cor1,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverSection(_buildHeader()),
            _buildSliverSection(_buildDescription()),
            _buildSliverSection(_buildVoicedCharacters()),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: _buildAppBarGradient(),
    title: const Text(
      'Detalhes do Personagem',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
  );

  Widget _buildAppBarGradient() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.cor2],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );

  Widget _buildSliverSection(Widget child) => SliverToBoxAdapter(
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _AnimePersonImage(widget.animePerson),
      const SizedBox(width: 16),
      Expanded(child: _AnimePersonBasicInfo(widget.animePerson)),
    ],
  );

  Widget _buildVoicedCharacters() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SectionTitle('Vozes'),
      const SizedBox(height: 12),
      SizedBox(
        height: 170,
        child: FutureBuilder<List<Voice>>(
          future: ApiService.buscarVoiceActors(
            int.parse(widget.animePerson.id),
          ), // Assuming AnimePerson has an 'id'
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "Sem dados disponíveis.",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return VoiceCard(personAnime: snapshot.data![index]);
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
            );
          },
        ),
      ),
    ],
  );

  Widget _buildDescription() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SectionTitle('Biografia'),
      const SizedBox(height: 12),
      _ExpandableDescription(
        widget.animePerson.biografia ?? 'Biografia não disponível.',
        _expandedDesc,
        () => setState(() => _expandedDesc = !_expandedDesc),
      ),
    ],
  );

  void _navigateToAllCharacters(
    BuildContext context,
    List<AnimePerson> characters,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllCharactersScreen(listaPersonagens: characters),
      ),
    );
  }
}

class _AnimePersonImage extends StatelessWidget {
  final AnimePerson animePerson;
  const _AnimePersonImage(this.animePerson);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: animePerson.imagemUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey[800]),
              errorWidget:
                  (_, __, ___) => Container(
                    color: const Color.fromARGB(255, 71, 71, 71),
                    child: const Icon(Icons.error, color: Colors.white),
                  ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.record_voice_over,
                    color: Colors.amber,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    animePerson.funcao ?? 'Role',
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
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimePersonBasicInfo extends StatelessWidget {
  final AnimePerson animePerson;
  const _AnimePersonBasicInfo(this.animePerson);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          animePerson.nome,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _InfoRow('Idade', animePerson.idade ?? 'N/A'),
        _InfoRow('Gênero', _translateGender(animePerson.genero ?? 'N/A')),
        _InfoRow('Favoritos', animePerson.favoritos ?? 'N/A'),
        _InfoRow('Nascimento', animePerson.nascimento ?? 'N/A'),
      ],
    );
  }

  String _translateGender(String gender) =>
      {
        'Male': 'Masculino',
        'Female': 'Feminino',
        'Non-binary': 'Não-binário',
        'Other': 'Outro',
      }[gender] ??
      gender;
}

class _ExpandableDescription extends StatelessWidget {
  final String description;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _ExpandableDescription(
    this.description,
    this.isExpanded,
    this.onToggle,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: _buildCollapsedDesc(),
          secondChild: _buildExpandedDesc(),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        TextButton(
          onPressed: onToggle,
          child: Text(
            isExpanded ? 'Mostrar menos' : 'Mostrar mais',
            style: TextStyle(color: Colors.amber[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedDesc() => Text(
    description.isNotEmpty ? description : 'Descrição não disponível',
    maxLines: 4,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(color: Colors.white70, height: 1.5),
  );

  Widget _buildExpandedDesc() => Text(
    description,
    style: const TextStyle(color: Colors.white70, height: 1.5),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 4,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
