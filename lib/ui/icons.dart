import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';

/// Symbole für Spiel-IDs (alles aus dem gebündelten Material-Icon-Font).
abstract final class GameIcons {
  static IconData effect(String id) => switch (id) {
    'caffeine' => Icons.coffee_rounded,
    'teamgeist' => Icons.groups_rounded,
    'adrenaline' => Icons.bolt_rounded,
    'eagle_eye' => Icons.visibility_rounded,
    'focused' => Icons.center_focus_strong_rounded,
    'bright' => Icons.flashlight_on_rounded,
    'hidden' => Icons.visibility_off_rounded,
    'injured' => Icons.personal_injury_rounded,
    'panic' => Icons.sentiment_very_dissatisfied_rounded,
    'poisoned' => Icons.science_rounded,
    'blinded' => Icons.blur_on_rounded,
    'suspicious' => Icons.report_rounded,
    _ => Icons.auto_awesome,
  };

  static IconData item(String type) => switch (type) {
    ItemType.coffee => Icons.coffee_rounded,
    ItemType.battery => Icons.battery_charging_full_rounded,
    ItemType.salts => Icons.spa_rounded,
    ItemType.antidote => Icons.vaccines_rounded,
    ItemType.medkit => Icons.medical_services_rounded,
    ItemType.flare => Icons.local_fire_department_rounded,
    ItemType.trace => Icons.blur_on_rounded,
    _ => Icons.inventory_2_rounded,
  };

  static IconData cls(String id) => switch (id) {
    'forensic' => Icons.biotech_rounded,
    'profiler' => Icons.psychology_rounded,
    'excop' => Icons.local_police_rounded,
    'journalist' => Icons.newspaper_rounded,
    'medic' => Icons.medical_services_rounded,
    _ => Icons.person_search_rounded,
  };

  static IconData ability(String id) => switch (id) {
    'scan' => Icons.visibility_rounded,
    'calm' => Icons.self_improvement_rounded,
    'scare' => Icons.campaign_rounded,
    'sources' => Icons.travel_explore_rounded,
    'firstaid' => Icons.healing_rounded,
    _ => Icons.auto_awesome,
  };

  static IconData emote(String id) => switch (id) {
    'wave' => Icons.waving_hand_rounded,
    'shock' => Icons.priority_high_rounded,
    'think' => Icons.psychology_alt_rounded,
    'laugh' => Icons.sentiment_very_satisfied_rounded,
    'scared' => Icons.mood_bad_rounded,
    'thumbs' => Icons.thumb_up_rounded,
    _ => Icons.emoji_people_rounded,
  };

  static IconData quick(String id) => switch (id) {
    'come_here' => Icons.near_me_rounded,
    'found_clue' => Icons.search_rounded,
    'help' => Icons.sos_rounded,
    'stay_together' => Icons.group_work_rounded,
    'split_up' => Icons.call_split_rounded,
    'suspect' => Icons.person_search_rounded,
    'danger' => Icons.warning_amber_rounded,
    'thanks' => Icons.favorite_rounded,
    _ => Icons.chat_bubble_rounded,
  };

  static IconData clueKind(String kind) => switch (kind) {
    ClueKind.trait => Icons.fingerprint_rounded,
    ClueKind.motive => Icons.attach_money_rounded,
    ClueKind.weapon => Icons.gavel_rounded,
    ClueKind.alibi => Icons.schedule_rounded,
    ClueKind.story => Icons.history_edu_rounded,
    'sighting' => Icons.remove_red_eye_rounded,
    _ => Icons.description_rounded,
  };

  static IconData award(String id) => switch (id) {
    'spurensucher' => Icons.search_rounded,
    'lebensretter' => Icons.favorite_rounded,
    'kombinierer' => Icons.hub_rounded,
    'ueberlebender' => Icons.shield_rounded,
    'geist' => Icons.blur_circular_rounded,
    'teamplayer' => Icons.handshake_rounded,
    _ => Icons.military_tech_rounded,
  };

  static IconData achievement(String id) => switch (id) {
    'first_case' => Icons.folder_open_rounded,
    'perfect' => Icons.verified_rounded,
    'all_survived' => Icons.groups_rounded,
    'revive3' => Icons.volunteer_activism_rounded,
    'secret' => Icons.lock_open_rounded,
    'all_scenarios' => Icons.inventory_rounded,
    'streak5' => Icons.local_fire_department_rounded,
    'ghost_helper' => Icons.blur_circular_rounded,
    'online' => Icons.public_rounded,
    'combos10' => Icons.hub_rounded,
    _ => Icons.emoji_events_rounded,
  };

  static IconData topic(String topic) => switch (topic) {
    Topic.alibi => Icons.schedule_rounded,
    Topic.victim => Icons.person_off_rounded,
    Topic.observation => Icons.visibility_rounded,
    Topic.rumor => Icons.record_voice_over_rounded,
    _ => Icons.chat_rounded,
  };
}
