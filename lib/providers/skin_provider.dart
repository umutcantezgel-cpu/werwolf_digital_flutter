import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents a Card Back skin for the role reveal animation.
class CardBackSkin {
  final String id;
  final String name;
  final String assetPath;
  final bool isPremium;

  const CardBackSkin({
    required this.id,
    required this.name,
    required this.assetPath,
    this.isPremium = false,
  });

  static const CardBackSkin defaultSkin = CardBackSkin(
    id: 'default',
    name: 'Classic',
    assetPath: 'assets/images/card_backs/default.png',
  );

  static const List<CardBackSkin> availableSkins = [
    defaultSkin,
    CardBackSkin(
      id: 'midnight',
      name: 'Midnight Moon',
      assetPath: 'assets/images/card_backs/midnight.png',
    ),
    CardBackSkin(
      id: 'blood',
      name: 'Blood Moon',
      assetPath: 'assets/images/card_backs/blood.png',
      isPremium: true,
    ),
    CardBackSkin(
      id: 'forest',
      name: 'Forest Mist',
      assetPath: 'assets/images/card_backs/forest.png',
      isPremium: true,
    ),
    CardBackSkin(
      id: 'golden',
      name: 'Golden Eclipse',
      assetPath: 'assets/images/card_backs/golden.png',
      isPremium: true,
    ),
  ];
}

/// Represents a Voice Pack for narration.
class VoicePack {
  final String id;
  final String name;
  final String description;
  final String pathPrefix;
  final bool isPremium;

  const VoicePack({
    required this.id,
    required this.name,
    required this.description,
    required this.pathPrefix,
    this.isPremium = false,
  });

  static const VoicePack defaultPack = VoicePack(
    id: 'default',
    name: 'Classic Narrator',
    description: 'Der klassische, mystische Erzähler.',
    pathPrefix: 'voice/default',
  );

  static const List<VoicePack> availablePacks = [
    defaultPack,
    VoicePack(
      id: 'horror_host',
      name: 'Horror Host',
      description: 'Ein gruseliger Horrorfilm-Moderator.',
      pathPrefix: 'voice/horror_host',
      isPremium: true,
    ),
    VoicePack(
      id: 'sassy_ai',
      name: 'Sassy AI',
      description: 'Eine freche, moderne KI-Stimme.',
      pathPrefix: 'voice/sassy_ai',
      isPremium: true,
    ),
    VoicePack(
      id: 'grandma',
      name: 'Märchen-Oma',
      description: 'Eine liebevolle Großmutter erzählt die Geschichte.',
      pathPrefix: 'voice/grandma',
      isPremium: true,
    ),
  ];
}

/// Provider for managing skin and voice pack selections.
class SkinProvider extends ChangeNotifier {
  static const String _cardBackKey = 'selected_card_back';
  static const String _voicePackKey = 'selected_voice_pack';

  CardBackSkin _selectedCardBack = CardBackSkin.defaultSkin;
  VoicePack _selectedVoicePack = VoicePack.defaultPack;

  CardBackSkin get selectedCardBack => _selectedCardBack;
  VoicePack get selectedVoicePack => _selectedVoicePack;

  List<CardBackSkin> get availableCardBacks => CardBackSkin.availableSkins;
  List<VoicePack> get availableVoicePacks => VoicePack.availablePacks;

  /// Initialize from SharedPreferences.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final cardBackId = prefs.getString(_cardBackKey);
    if (cardBackId != null) {
      _selectedCardBack = CardBackSkin.availableSkins.firstWhere(
        (s) => s.id == cardBackId,
        orElse: () => CardBackSkin.defaultSkin,
      );
    }

    final voicePackId = prefs.getString(_voicePackKey);
    if (voicePackId != null) {
      _selectedVoicePack = VoicePack.availablePacks.firstWhere(
        (p) => p.id == voicePackId,
        orElse: () => VoicePack.defaultPack,
      );
    }

    notifyListeners();
  }

  /// Select a new card back and persist.
  Future<void> selectCardBack(CardBackSkin skin) async {
    if (_selectedCardBack.id == skin.id) return;

    _selectedCardBack = skin;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cardBackKey, skin.id);
  }

  /// Select a new voice pack and persist.
  Future<void> selectVoicePack(VoicePack pack) async {
    if (_selectedVoicePack.id == pack.id) return;

    _selectedVoicePack = pack;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_voicePackKey, pack.id);
  }

  /// Get the full audio path for a voice file using the selected pack.
  String getVoicePath(String filename) {
    return '${_selectedVoicePack.pathPrefix}/$filename';
  }
}
