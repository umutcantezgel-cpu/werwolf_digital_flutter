import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../haptics.dart';
import '../icons.dart';
import 'game_context.dart';
import 'toasts.dart';

enum Haptic { none, light, medium, heavy, selection }

void haptic(Haptic h) {
  switch (h) {
    case Haptic.light:
      Haptics.light();
    case Haptic.medium:
      Haptics.medium();
    case Haptic.heavy:
      Haptics.heavy();
    case Haptic.selection:
      Haptics.selection();
    case Haptic.none:
      break;
  }
}

/// Baut aus einem Ereignis einen Toast (+ Haptik). Dialog-Ereignisse behandelt das Verhör.
void showEventToast(GameEvent e, GameCtx g, ToastController toasts) {
  final l = g.l;
  final me = g.me;
  void t(String text, IconData icon, Color color, [Haptic h = Haptic.light]) {
    toasts.show(text, icon: icon, color: color);
    haptic(h);
  }

  final player = e.str('player');
  final by = e.str('by');
  switch (e.type) {
    case Ev.clueFound:
      t(l.toast_clue_found(g.clueName(e.str('clue'))), Icons.search_rounded, Noir.brass, Haptic.medium);
    case Ev.hotspotEmpty:
      t(l.toast_hotspot_empty(g.nameOf(by)), Icons.do_not_disturb_on_rounded, Noir.smoke);
    case Ev.nothingFound:
      final h = e.str('hotspot') ?? '';
      if (h.startsWith('trace_')) {
        t(l.toast_trace_nothing, Icons.blur_on_rounded, Noir.smoke);
      } else {
        t(l.toast_nothing_found(g.hotspotName(h)), Icons.search_off_rounded, Noir.smoke);
      }
    case Ev.clueShared:
      if (by == me) {
        t(l.toast_clue_shared_me(g.clueName(e.str('clue'))), Icons.push_pin_rounded, Noir.brass, Haptic.selection);
      } else {
        t(l.toast_clue_shared(g.nameOf(by), g.clueName(e.str('clue'))), Icons.push_pin_rounded, Noir.brass);
      }
    case Ev.clueEvolved:
      t(l.toast_clue_evolved(g.clueName(e.str('clue'))), Icons.science_rounded, Noir.lab, Haptic.medium);
    case Ev.clueLost:
      final clue = g.clueName(e.str('clue'));
      final text = switch (e.str('mode')) {
        'damaged' => l.toast_clue_lost_damaged(clue),
        'stolen' => l.toast_clue_lost_stolen(clue),
        _ => l.toast_clue_lost(clue),
      };
      t(text, Icons.local_fire_department_rounded, Noir.debuff, Haptic.heavy);
    case Ev.cluesFaded:
      t(l.toast_clues_faded(e.integer('count') ?? 1), Icons.hourglass_empty_rounded, Noir.smoke);
    case Ev.combo:
      t(l.toast_combo(g.comboName(e.str('combo'))), Icons.hub_rounded, Noir.brassLight, Haptic.heavy);
    case Ev.comboFail:
      t(l.toast_combo_fail, Icons.link_off_rounded, Noir.smoke);
    case Ev.comboKnown:
      t(l.toast_combo_known(g.comboName(e.str('combo'))), Icons.hub_outlined, Noir.smoke);
    case Ev.dialogueRefused:
      final npc = g.npcName(e.str('npc'));
      final text = switch (e.str('reason')) {
        'dead' => l.toast_refused_dead(npc),
        'busy' => l.toast_refused_busy(npc),
        _ => l.toast_refused_silenced(npc),
      };
      t(text, Icons.voice_over_off_rounded, Noir.debuff);
    case Ev.contradiction:
      t(l.toast_contradiction(g.npcName(e.str('npc'))), Icons.gavel_rounded, Noir.brassLight, Haptic.heavy);
    case Ev.effect:
      if (player != me) return;
      final id = e.str('effect') ?? '';
      final buff = effectCatalog[id]?.buff ?? true;
      if (e.flag('on')) {
        t(l.toast_effect_on(l.effectName(id), l.effectDesc(id)), GameIcons.effect(id), buff ? Noir.buff : Noir.debuff);
      } else {
        t(l.toast_effect_off(l.effectName(id)), GameIcons.effect(id), Noir.smoke, Haptic.none);
      }
    case Ev.attacked:
      if (player == me) {
        t(l.toast_attacked_me, Icons.warning_rounded, Noir.bloodBright, Haptic.heavy);
      } else {
        t(l.toast_attacked(g.nameOf(player)), Icons.warning_rounded, Noir.bloodBright, Haptic.medium);
      }
    case Ev.downed:
      if (player == me) {
        t(l.toast_downed_me, Icons.personal_injury_rounded, Noir.bloodBright, Haptic.heavy);
      } else {
        t(l.toast_downed(g.nameOf(player)), Icons.sos_rounded, Noir.bloodBright, Haptic.medium);
      }
    case Ev.revived:
      if (by == 'dawn') {
        t(
          player == me ? l.toast_revived_dawn_me : l.toast_revived_dawn(g.nameOf(player)),
          Icons.wb_twilight_rounded,
          Noir.dawn,
          Haptic.medium,
        );
      } else if (player == me) {
        t(l.toast_revived_me(g.nameOf(by)), Icons.favorite_rounded, Noir.buff, Haptic.medium);
      } else {
        t(l.toast_revived(g.nameOf(by), g.nameOf(player)), Icons.favorite_rounded, Noir.buff);
      }
    case Ev.died:
      if (player == me) {
        t(l.toast_died_me, Icons.blur_circular_rounded, Noir.ghost, Haptic.heavy);
      } else {
        t(l.toast_died(g.nameOf(player, youForMe: false)), Icons.dangerous_rounded, Noir.bloodBright, Haptic.heavy);
      }
    case Ev.npcKilled:
      t(l.toast_npc_killed(g.npcName(e.str('npc'))), Icons.dangerous_rounded, Noir.bloodBright, Haptic.heavy);
    case Ev.shadowRepelled:
      final text = switch (e.str('reason')) {
        'scare' => l.toast_repelled_scare(g.nameOf(by)),
        'flare' => l.toast_repelled_flare,
        _ => l.toast_repelled_group,
      };
      t(text, Icons.shield_rounded, Noir.buff, Haptic.medium);
    case Ev.leadChosen:
      t(l.toast_lead_chosen(g.leadName(e.str('lead'))), Icons.alt_route_rounded, g.accent, Haptic.medium);
    case Ev.signal:
      final kind = e.str('kind');
      final value = e.str('value') ?? '';
      if (kind == 'ping') {
        t(l.toast_ping(g.nameOf(by)), Icons.place_rounded, g.accent, Haptic.selection);
      } else if (kind == 'quick') {
        final danger = value == 'help' || value == 'danger';
        t(
          l.toast_signal(g.nameOf(by), '„${l.quickText(value)}“'),
          GameIcons.quick(value),
          danger ? Noir.bloodBright : Noir.paper,
          danger ? Haptic.medium : Haptic.selection,
        );
      } else {
        t(l.toast_signal(g.nameOf(by), l.emoteLabel(value)), GameIcons.emote(value), Noir.paper, Haptic.selection);
      }
    case Ev.itemPicked:
      final type = e.str('type') ?? '';
      if (type == ItemType.trace) {
        if (by == me) t(l.toast_trace_search, Icons.blur_on_rounded, Noir.trace, Haptic.medium);
      } else if (by == me) {
        t(l.toast_item_picked(l.itemName(type)), GameIcons.item(type), Noir.brass, Haptic.selection);
      }
    case Ev.itemUsed:
      final type = e.str('type') ?? '';
      if (by == me) {
        t(l.toast_item_used_me(l.itemName(type)), GameIcons.item(type), Noir.buff, Haptic.medium);
      } else if (type == ItemType.flare || type == ItemType.medkit) {
        t(l.toast_item_used(g.nameOf(by), l.itemName(type)), GameIcons.item(type), Noir.buff);
      }
    case Ev.ability:
      final ability = e.str('ability') ?? '';
      if (player == me) {
        t(l.toast_ability_me(l.abilityName(ability)), GameIcons.ability(ability), g.accent, Haptic.medium);
      } else {
        t(l.toast_ability(g.nameOf(player), l.abilityName(ability)), GameIcons.ability(ability), g.accent);
      }
    case Ev.sources:
      t(l.toast_sources(g.hotspotName(e.str('hotspot'))), Icons.travel_explore_rounded, g.accent, Haptic.medium);
    case Ev.labDone:
      t(l.toast_lab_done(e.integer('count') ?? 0), Icons.science_rounded, Noir.lab, Haptic.medium);
    case Ev.hide:
      if (player != me) return;
      t(e.flag('hidden') ? l.toast_hidden : l.toast_unhidden, Icons.door_sliding_rounded, Noir.smoke, Haptic.selection);
    case Ev.error:
      t(l.errorText(e.str('key') ?? ''), Icons.block_rounded, Noir.debuff, Haptic.light);
    case Ev.shadowNear:
      // Herzschlag-Vignette statt Toast (siehe GameScreen)
      break;
  }
}
