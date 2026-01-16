import 'package:flutter/material.dart';
import '../models/role.dart';
import 'design_tokens.dart';

// A map holding the details for each role.
const Map<RoleType, Role> roles = {
  // --- VILLAGE TEAM ---
  RoleType.dorfbewohner: Role(
    type: RoleType.dorfbewohner,
    name: 'Dorfbewohner',
    description: 'Du bist ein einfacher Dorfbewohner. Finde die Werwölfe!',
    team: Team.dorf,
    imageUrl: 'assets/images/roles/dorfbewohner.png',
    ability: 'Keine besondere Fähigkeit. Nutze Beobachtungsgabe und Logik.',
    flavorText: '"In diesen dunklen Zeiten ist jeder verdächtig..."',
    nightPriority: -1,
    icon: Icons.person,
    color: DesignColors.roleDorfbewohner,
  ),
  RoleType.seherin: Role(
    type: RoleType.seherin,
    name: 'Seherin',
    description: 'Du kannst jede Nacht die Identität eines Spielers sehen.',
    team: Team.dorf,
    imageUrl: 'assets/images/roles/seherin.png',
    ability: 'Erfahre jede Nacht, ob ein Spieler ein Werwolf ist oder nicht.',
    flavorText: '"Die Wahrheit verbirgt sich nicht vor meinen Augen..."',
    nightPriority: 30,
    hasNightAction: true,
    actionType: ActionType.investigate,
    icon: Icons.visibility,
    color: DesignColors.roleSeherin,
  ),
  RoleType.hexe: Role(
    type: RoleType.hexe,
    name: 'Hexe',
    description: 'Du hast einen Heil- und einen Gifttrank.',
    team: Team.dorf,
    imageUrl: 'assets/images/roles/hexe.png',
    ability: 'Heile das Opfer der Werwölfe oder töte einen Spieler.',
    flavorText: '"Meine Tränke können Leben retten... oder nehmen."',
    nightPriority: 60,
    hasNightAction: true,
    actionType: ActionType.potions,
    icon: Icons.science,
    color: DesignColors.roleHexe,
  ),
  RoleType.jager: Role(
    type: RoleType.jager,
    name: 'Jäger',
    description: 'Wenn du stirbst, nimmst du jemanden mit.',
    team: Team.dorf,
    imageUrl: 'assets/images/roles/jager.png',
    ability: 'Wähle beim Tod einen Spieler, der ebenfalls stirbt.',
    flavorText: '"Meine letzte Kugel gehört dir..."',
    triggeredAbility: TriggerType.onDeath,
    icon: Icons.gps_fixed,
    color: DesignColors.roleJager,
  ),
  RoleType.amor: Role(
    type: RoleType.amor,
    name: 'Amor',
    description: 'Wähle zwei Liebende, die verbunden sind.',
    team: Team.dorf, // Can create Lovers team
    imageUrl: 'assets/images/roles/amor.png',
    ability: 'Bestimme in der ersten Nacht zwei Spieler als Liebespaar.',
    flavorText: '"Die Liebe ist stärker als der Tod... manchmal."',
    nightPriority: 10,
    hasNightAction: true,
    actionType: ActionType.selectTwo,
    onlyFirstNight: true,
    icon: Icons.favorite,
    color: DesignColors.roleAmor,
  ),
  RoleType.leibwachter: Role(
    type: RoleType.leibwachter,
    name: 'Leibwächter',
    description: 'Beschütze jede Nacht einen Spieler vor den Werwölfen.',
    team: Team.dorf,
    imageUrl: 'assets/images/roles/leibwachter.png',
    ability:
        'Wähle einen Spieler, der diese Nacht nicht gefressen werden kann.',
    flavorText: '"Solange ich atme, wirst du leben."',
    nightPriority: 40,
    hasNightAction: true,
    actionType: ActionType.protect,
    icon: Icons.shield,
    color: Color(0xFF607D8B), // Steel Blue
  ),
  RoleType.burgermeister: Role(
    type: RoleType.burgermeister,
    name: 'Bürgermeister',
    description: 'Deine Stimme zählt doppelt.',
    team: Team.dorf,
    imageUrl: 'assets/images/roles/burgermeister.png',
    ability: 'Deine Stimme zählt bei Abstimmungen doppelt.',
    flavorText: '"Das Wohl des Dorfes liegt in meinen Händen."',
    passiveAbility: PassiveType.doubleVote,
    triggeredAbility: TriggerType.onDeath, // Transfers title
    icon: Icons.local_police, // Badge
    color: Color(0xFFFFD700), // Gold
  ),
  RoleType.dorftrottel: Role(
    type: RoleType.dorftrottel,
    name: 'Dorftrottel',
    description: 'Du überlebst deine erste Hinrichtung.',
    team: Team.dorf,
    imageUrl: 'assets/images/roles/dorftrottel.png',
    ability:
        'Falls du gewählt wirst, offenbart sich deine Rolle und du lebst weiter.',
    flavorText: '"Haha! Ihr könnt mich nicht töten..."',
    triggeredAbility: TriggerType.onExecution,
    icon: Icons.mood,
    color: Colors.orange,
  ),
  RoleType.madchen: Role(
    type: RoleType.madchen,
    name: 'Mädchen',
    description: 'Du darfst nachts heimlich blinzeln.',
    team: Team.dorf,
    imageUrl: 'assets/images/roles/madchen.png',
    ability: 'Versuche, die Werwölfe zu erkennen. Lass dich nicht erwischen!',
    flavorText: '"Ich habe etwas gesehen... aber wer glaubt schon einem Kind?"',
    passiveAbility: PassiveType.peek,
    icon: Icons.face_3,
    color: Colors.pinkAccent,
  ),

  // --- WEREWOLF TEAM ---
  RoleType.werwolf: Role(
    type: RoleType.werwolf,
    name: 'Werwolf',
    description:
        'Fresse jede Nacht gemeinsam mit dem Rudel einen Dorfbewohner.',
    team: Team.werwolf,
    imageUrl: 'assets/images/roles/werwolf.png',
    ability: 'Erwache mit den anderen Werwölfen und wähle ein Opfer.',
    flavorText: '"Der Hunger treibt uns... die Nacht gehört uns."',
    nightPriority: 50,
    hasNightAction: true,
    actionType: ActionType.kill,
    seesTeammates: true,
    icon: Icons.nights_stay,
    color: DesignColors.roleWerwolf,
  ),
  RoleType.urwolf: Role(
    type: RoleType.urwolf,
    name: 'Urwolf',
    description: 'Du kannst einmalig das Opfer in einen Werwolf verwandeln.',
    team: Team.werwolf,
    imageUrl: 'assets/images/roles/urwolf.png',
    ability: 'Einmal pro Spiel kannst du das Opfer infizieren statt zu töten.',
    flavorText: '"Willkommen in der Familie..."',
    nightPriority: 50,
    hasNightAction: true,
    actionType: ActionType.killOrConvert,
    seesTeammates: true,
    icon: Icons.coronavirus,
    color: Color(0xFF4A148C), // Deep Purple
  ),
  RoleType.grosserBoserWolf: Role(
    type: RoleType.grosserBoserWolf,
    name: 'Großer Böser Wolf',
    description:
        'Du kannst jede Nacht ein zweites Opfer wählen, solange kein Wolf stirbt.',
    team: Team.werwolf,
    imageUrl: 'assets/images/roles/grosser_boser_wolf.png',
    ability: 'Wähle ein zweites Opfer, wenn alle Wölfe noch leben.',
    flavorText: '"Ein Opfer ist niemals genug..."',
    nightPriority: 55,
    hasNightAction: true,
    actionType: ActionType.kill, // Special logic handles the "second" kill
    seesTeammates: true,
    icon: Icons.copy_all,
    color: Color(0xFFB71C1C), // Stronger red
  ),

  // --- NEUTRAL / SOLO ---
  RoleType.weisserWolf: Role(
    type: RoleType.weisserWolf,
    name: 'Weißer Wolf',
    description: 'Du bist ein Werwolf, aber du willst als Einziger überleben.',
    team: Team.werwolf, // Acts with wolves generally
    imageUrl: 'assets/images/roles/weisser_wolf.png',
    ability:
        'Erwache mit den Wölfen. Jede 2. Nacht kannst du einen Wolf töten.',
    flavorText: '"Am Ende werde nur ich übrig sein."',
    nightPriority: 55,
    hasNightAction: true,
    actionType: ActionType.killWerewolf,
    seesTeammates: true,
    winCondition: WinCondition.lastSurvivor,
  ),
  RoleType.flotenspieler: Role(
    type: RoleType.flotenspieler,
    name: 'Flötenspieler',
    description: 'Verzaubere jede Nacht zwei Spieler.',
    team: Team.neutral,
    imageUrl: 'assets/images/roles/flotenspieler.png',
    ability: 'Gewinne, wenn alle lebenden Spieler verzaubert sind.',
    flavorText: '"Tanzt nach meiner Pfeife..."',
    nightPriority: 70,
    hasNightAction: true,
    actionType: ActionType.enchant,
    winCondition: WinCondition.allEnchanted,
  ),

  // --- SPECIAL ---
  RoleType.unassigned: Role(
    type: RoleType.unassigned,
    name: 'Unbekannt',
    description: 'Noch keine Rolle zugewiesen.',
    team: Team.dorf,
    imageUrl: 'assets/images/roles/unassigned.png',
  ),
};

// Game Phases
enum GamePhase {
  lobby,
  roleDistribution,
  roleReveal, // Players viewing their cards
  firstNight, // Cupid, etc.
  night,
  dawn, // Sunrise animation / announcements
  day,
  nomination, // For voting specific players
  defense, // Accused player speaks
  voting,
  execution, // Animation of death
  tragedy, // Death announcement
  victory, // Game Over / Win screen
  gameOver,
}
