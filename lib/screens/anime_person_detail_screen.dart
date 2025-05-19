import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../colors/app_colors.dart';
import '../api_service.dart';
import '../models/anime_person.dart';
import '../../models/character.dart';
import '../widgets/voice_card.dart';
import '../models/voice.dart';

class AnimePersonDetailScreen extends StatefulWidget {
  final AnimePerson animePerson;

  const AnimePersonDetailScreen({Key? key, required this.animePerson})
    : super(key: key);

  @override
  State<AnimePersonDetailScreen> createState() =>
      _AnimePersonDetailScreenState();
}

class _AnimePersonDetailScreenState extends State<AnimePersonDetailScreen> {
  bool _expandedDesc = false;
  bool _isLoading = true;
  Character? _characterDetails;
  String _errorMessage = '';
  bool _bioExceedsMaxLines = false;

  @override
  void initState() {
    super.initState();
    _loadCharacterDetails();
  }

  Future<void> _loadCharacterDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final details = await ApiService.buscarPersonagens(
        widget.animePerson.character.malId,
      );

      if (!mounted) return;

      setState(() {
        _characterDetails = details.first.character;
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkBioLength();
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Erro ao carregar detalhes: $e';
        _isLoading = false;
      });
    }
  }

  void _checkBioLength() {
    final bio = _characterDetails?.bio ?? '';
    if (bio.isEmpty) {
      setState(() => _bioExceedsMaxLines = false);
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width - 32;
    final charsPerLine = screenWidth / 8;

    setState(() {
      _bioExceedsMaxLines = bio.length > (charsPerLine * 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cor1,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                )
                : _errorMessage.isNotEmpty
                ? _buildErrorState()
                : _buildContent(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadCharacterDetails,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverSection(_buildHeader()),
        if (_characterDetails?.nicknames?.isNotEmpty == true)
          _buildSliverSection(_buildNicknames()),
        _buildSliverSection(_buildDescription()),
        _buildSliverSection(_buildVoicedCharacters()),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.cor2, AppColors.cor2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
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
  }

  Widget _buildSliverSection(Widget child) {
    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimePersonImage(widget.animePerson),
        const SizedBox(width: 16),
        Expanded(
          child: AnimePersonBasicInfo(widget.animePerson, _characterDetails),
        ),
      ],
    );
  }

  Widget _buildVoicedCharacters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Vozes'),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: FutureBuilder<List<Voice>>(
            future: ApiService.buscarVoiceActors(
              widget.animePerson.character.malId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || snapshot.data?.isEmpty == true) {
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
                itemBuilder:
                    (context, index) => VoiceCard(voice: snapshot.data![index]),
                separatorBuilder: (context, _) => const SizedBox(width: 12),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Biografia'),
        const SizedBox(height: 12),
        ExpandableDescription(
          _characterDetails?.bio ?? 'Biografia indisponível.',
          _expandedDesc,
          () => setState(() => _expandedDesc = !_expandedDesc),
          showExpandButton: _bioExceedsMaxLines,
        ),
      ],
    );
  }

  Widget _buildNicknames() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Apelidos'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _characterDetails!.nicknames!
                  .map(
                    (nickname) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        nickname,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

class AnimePersonImage extends StatelessWidget {
  final AnimePerson animePerson;

  const AnimePersonImage(this.animePerson, {Key? key}) : super(key: key);

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
              imageUrl: animePerson.character.images.jpg.imageUrl,
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
                    animePerson.role,
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

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow(this.label, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(color: Colors.white, fontSize: 14),
          children: [
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

class AnimePersonBasicInfo extends StatelessWidget {
  final AnimePerson animePerson;
  final Character? characterDetails;

  const AnimePersonBasicInfo(
    this.animePerson,
    this.characterDetails, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          animePerson.character.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        if (characterDetails?.kanjiName != null &&
            characterDetails!.kanjiName!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              characterDetails!.kanjiName!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        const SizedBox(height: 12),
        InfoRow(
          'Favorito',
          (characterDetails?.favorite ?? animePerson.favorites).toString(),
        ),
        InfoRow('ID', animePerson.character.malId.toString()),
        InfoRow('Função', animePerson.role),
      ],
    );
  }
}

class ExpandableDescription extends StatelessWidget {
  final String description;
  final bool isExpanded;
  final VoidCallback onToggle;
  final bool showExpandButton;

  const ExpandableDescription(
    this.description,
    this.isExpanded,
    this.onToggle, {
    this.showExpandButton = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: _buildCollapsed(),
          secondChild: _buildExpanded(),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        if (showExpandButton)
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

  Widget _buildCollapsed() => Text(
    description,
    maxLines: 5,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(color: Colors.white70, height: 1.5),
  );

  Widget _buildExpanded() => Text(
    description,
    style: const TextStyle(color: Colors.white70, height: 1.5),
  );
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {Key? key}) : super(key: key);

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
