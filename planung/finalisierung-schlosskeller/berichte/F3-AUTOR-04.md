ABNAHME F3-AUTOR-04 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 1 · Grenzen 2 · Summe 9/10 (E-027)

# Bericht F3-AUTOR-04

## Ergebnis F3-AUTOR-04
- Geänderte Dateien: /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/dossiers-b4.json (keine andere Datei geändert)
- Umfang: 4 Einträge (serkan, aylin, kaan, dilara), 337 Wörter in Textfeldern ohne Verweise, 29 Sätze, Mittel 11,6 Wörter je Satz
- Längster Satz: 19 Wörter, dilara.wer („Man erkennt dich an der kleinen Lupe an deiner Silberkette und an deinen auffälligen Ringen aus Holz und Stein.“)
- Tests: `00:00 +7: All tests passed!` (dart test test/party/texte_test.dart, nach der letzten Änderung). JSON mit json.tool gültig. CLI bin/party_texte.dart meldet keinen Befund in dieser Datei.
- Verweise je Rolle: serkan: 1, aylin: 1, kaan: 4 (3 Beobachtungen, 1 Nebendelikt), dilara: 4 (4 Beobachtungen)

## OFFENE FRAGEN
1. serkan und aylin, Feld verbirgt: Der Auszug nennt weder verborgene Beobachtungen noch Lügen oder Nebendelikt. grundVerborgen und loyalitaet fehlen ebenfalls. Ich habe je einen Platzhalter „OFFENE FRAGE: …“ als Textpunkt gesetzt. Er ist sichtbarer Text und darf nicht unverändert ausgeliefert werden. Zu entscheiden ist, ob ein Schweige-Satz ergänzt oder verbirgt leer bleibt. Für Aylin wäre ein Satz aus persoenlichesZiel denkbar („ohne Ahmet vor allen bloßzustellen“). Den habe ich nicht gesetzt, weil die Regel grundVerborgen oder loyalitaet verlangt.
2. Kanon-Befund in beobachtungen.json#b_wojtek_vorbei (nicht geändert): Der Satz enthält „in den Turm“. Der Textlint meldet „Turm“ als Raumwort, weil es in raeume.json kein Raumname ist. Mein kaan-Dossier verweist auf diese Beobachtung, der Satz erscheint also am Tisch. Entscheidung beim Orchestrator (z. B. „in den Turmgang“ oder Kanon-Änderung).
3. Die übrigen sieben CLI-Befunde liegen in anderen Dateien (nicht geändert): „Turm“ als Raumwort in dossiers-b1.json (2×), figuren.json (2×) und entscheidungen.json (1×), „Gang“ als Raumwort in dossiers-b1.json (1×), eine Satzlänge von 29 Wörtern in gegenstaende.json#spur_notiz_fehlende.zeigt.
4. Titel und Berufe folgen dem Auszug und den Nachbardossiers: Aylin und Azra in weiblicher Form, Serkan und Wojtek in männlicher Form (z. B. „Rettungssanitäter“, „Steuerfachangestellte“). Falls der Sensibilitätsleser neutrale Formen will, bitte entscheiden.
5. Bewusst nicht verwendet: herkunft (im Auszug kein Alltagsbezug, daher nichts erfunden), blackoutAlibi, startRoom, idleAnimation. Die Dossier-Regeln sehen sie nicht vor.
=== ENDE F3-AUTOR-04 · BEREIT ZUR RÜCKGABE ===
