import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/skin_provider.dart';
import '../config/design_tokens.dart';
import '../services/audio_manager.dart';
import '../services/haptic_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Screen for selecting Card Backs and Voice Packs.
class SkinSelectionScreen extends StatefulWidget {
  const SkinSelectionScreen({super.key});

  @override
  State<SkinSelectionScreen> createState() => _SkinSelectionScreenState();
}

class _SkinSelectionScreenState extends State<SkinSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.nightBlack,
      appBar: AppBar(
        backgroundColor: DesignColors.nightDeep,
        title: const Text(
          'ANPASSUNGEN',
          style: TextStyle(
            fontFamily: DesignTypography.fontDisplay,
            fontSize: DesignTypography.text2xl,
            color: DesignColors.moonPrimary,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: DesignColors.dayBright,
          labelColor: DesignColors.dayBright,
          unselectedLabelColor: DesignColors.moonPrimary.withOpacity(0.6),
          tabs: const [
            Tab(text: 'KARTEN', icon: Icon(Icons.style)),
            Tab(text: 'STIMMEN', icon: Icon(Icons.record_voice_over)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCardBacksTab(),
          _buildVoicePacksTab(),
        ],
      ),
    );
  }

  Widget _buildCardBacksTab() {
    final skinProvider = context.watch<SkinProvider>();

    return GridView.builder(
      padding: const EdgeInsets.all(DesignSpacings.s16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: DesignSpacings.s16,
        mainAxisSpacing: DesignSpacings.s16,
      ),
      itemCount: skinProvider.availableCardBacks.length,
      itemBuilder: (context, index) {
        final skin = skinProvider.availableCardBacks[index];
        final isSelected = skinProvider.selectedCardBack.id == skin.id;

        return _CardBackTile(
          skin: skin,
          isSelected: isSelected,
          onTap: () {
            HapticManager().impactLight();
            skinProvider.selectCardBack(skin);
          },
        ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn().scale();
      },
    );
  }

  Widget _buildVoicePacksTab() {
    final skinProvider = context.watch<SkinProvider>();

    return ListView.builder(
      padding: const EdgeInsets.all(DesignSpacings.s16),
      itemCount: skinProvider.availableVoicePacks.length,
      itemBuilder: (context, index) {
        final pack = skinProvider.availableVoicePacks[index];
        final isSelected = skinProvider.selectedVoicePack.id == pack.id;

        return _VoicePackTile(
          pack: pack,
          isSelected: isSelected,
          onTap: () {
            HapticManager().impactLight();
            skinProvider.selectVoicePack(pack);
          },
        ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn().slideX();
      },
    );
  }
}

class _CardBackTile extends StatelessWidget {
  final CardBackSkin skin;
  final bool isSelected;
  final VoidCallback onTap;

  const _CardBackTile({
    required this.skin,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DesignDurations.normal,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignSpacings.s8),
          border: Border.all(
            color: isSelected ? DesignColors.dayBright : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: DesignColors.dayBright.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignSpacings.s8 - 2),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Card Back Image
              Image.asset(
                skin.assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback gradient if image not found
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          DesignColors.nightDeep,
                          DesignColors.nightMid,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.style,
                        size: 48,
                        color: DesignColors.moonPrimary.withOpacity(0.5),
                      ),
                    ),
                  );
                },
              ),
              // Name Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(DesignSpacings.s8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skin.name,
                        style: const TextStyle(
                          fontFamily: DesignTypography.fontBody,
                          fontSize: DesignTypography.textBase,
                          color: DesignColors.moonPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (skin.isPremium)
                        const Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: DesignColors.dayBright,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'PREMIUM',
                              style: TextStyle(
                                fontFamily: DesignTypography.fontBody,
                                fontSize: DesignTypography.textXs,
                                color: DesignColors.dayBright,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              // Selected Checkmark
              if (isSelected)
                Positioned(
                  top: DesignSpacings.s8,
                  right: DesignSpacings.s8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: DesignColors.dayBright,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.black,
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

class _VoicePackTile extends StatelessWidget {
  final VoicePack pack;
  final bool isSelected;
  final VoidCallback onTap;

  const _VoicePackTile({
    required this.pack,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DesignDurations.normal,
        margin: const EdgeInsets.only(bottom: DesignSpacings.s16),
        padding: const EdgeInsets.all(DesignSpacings.s16),
        decoration: BoxDecoration(
          color: isSelected ? DesignColors.nightMid : DesignColors.nightDeep,
          borderRadius: BorderRadius.circular(DesignSpacings.s8),
          border: Border.all(
            color:
                isSelected ? DesignColors.dayBright : DesignColors.nightSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: DesignColors.nightSubtle,
                borderRadius: BorderRadius.circular(DesignSpacings.s4),
              ),
              child: Icon(
                Icons.record_voice_over,
                color: isSelected
                    ? DesignColors.dayBright
                    : DesignColors.moonPrimary.withOpacity(0.6),
                size: 28,
              ),
            ),
            const SizedBox(width: DesignSpacings.s16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        pack.name,
                        style: const TextStyle(
                          fontFamily: DesignTypography.fontBody,
                          fontSize: DesignTypography.textBase,
                          color: DesignColors.moonPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (pack.isPremium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: DesignColors.dayBright,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              fontFamily: DesignTypography.fontBody,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pack.description,
                    style: TextStyle(
                      fontFamily: DesignTypography.fontBody,
                      fontSize: DesignTypography.textSm,
                      color: DesignColors.moonPrimary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            // Preview Button
            IconButton(
              onPressed: () {
                HapticManager().selection();
                AudioManager().playSfx('${pack.pathPrefix}/preview.mp3');
              },
              icon: Icon(
                Icons.play_circle_outline,
                color: DesignColors.moonPrimary.withOpacity(0.8),
                size: 32,
              ),
            ),
            // Selected Checkmark
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: DesignColors.dayBright,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
