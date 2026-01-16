import 'package:flutter/material.dart';

// The different roles a player can have.
enum RoleType {
  // Village Team
  dorfbewohner,
  seherin,
  hexe,
  jager,
  amor,
  leibwachter,
  burgermeister,
  dorftrottel,
  madchen,

  // Werewolf Team
  werwolf,
  urwolf,
  grosserBoserWolf,

  // Neutral / Solo
  weisserWolf,
  flotenspieler,

  // Special
  unassigned,
}

// The team a role belongs to.
enum Team {
  dorf,
  werwolf,
  neutral,
  lovers,
}

// Types of night actions
enum ActionType {
  none,
  investigate, // Seer
  kill, // Werewolves
  protect, // Bodyguard
  potions, // Witch
  selectTwo, // Cupid
  killOrConvert, // Alpha Wolf
  killWerewolf, // White Wolf
  enchant, // Pied Piper
}

// Triggers for abilities
enum TriggerType {
  none,
  onDeath, // Hunter
  onExecution, // Fool
  onAttacked,
}

// Passive abilities
enum PassiveType {
  none,
  doubleVote, // Mayor
  seerImmune, // Alpha Wolf (converted)
  peek, // Little Girl
}

// Win conditions
enum WinCondition {
  teamWins,
  lastSurvivor,
  bothSurvive,
  targetExecuted,
  allEnchanted,
}

class Role {
  final RoleType type;
  final String name;
  final String description;
  final Team team;
  final String imageUrl;
  final String ability;
  final String flavorText;

  // Logic properties
  final int nightPriority; // -1 if no night action
  final bool hasNightAction;
  final ActionType actionType;
  final bool seesTeammates;
  final bool onlyFirstNight;
  final TriggerType triggeredAbility;
  final PassiveType passiveAbility;
  final WinCondition winCondition;
  final IconData? icon;
  final Color? color;

  const Role({
    required this.type,
    required this.name,
    required this.description,
    required this.team,
    this.imageUrl = 'assets/images/roles/unassigned.png',
    this.ability = '',
    this.flavorText = '',
    this.nightPriority = -1,
    this.hasNightAction = false,
    this.actionType = ActionType.none,
    this.seesTeammates = false,
    this.onlyFirstNight = false,
    this.triggeredAbility = TriggerType.none,
    this.passiveAbility = PassiveType.none,
    this.winCondition = WinCondition.teamWins,
    this.icon,
    this.color,
  });
}
