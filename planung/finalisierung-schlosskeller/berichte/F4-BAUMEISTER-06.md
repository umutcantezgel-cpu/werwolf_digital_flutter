ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 1 · Summe 9/10 (Grenzen: git log nur lesend; Zusatzbausteine Rückblende und Figur bestätigt)

# Bericht F4-BAUMEISTER-06

## Ergebnis F4-BAUMEISTER-06
- DATEIEN:
  - /home/user/werwolf_digital_flutter/lib/party/bildschirme/anklage.dart: 154 Zeilen
  - /home/user/werwolf_digital_flutter/lib/party/bildschirme/finale.dart: 41 Zeilen
  - /home/user/werwolf_digital_flutter/lib/party/bildschirme/aufloesung.dart: 120 Zeilen
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/ui-finale.json: 95 Zeilen
  - /home/user/werwolf_digital_flutter/test/party_widgets/finale_test.dart: 161 Zeilen (neu)
- UMGESETZT:
  - 1 → Die drei Konstruktoren `const XBildschirm({super.key, required this.sitzung})` bleiben. Anklage ist jetzt ein StatefulWidget für die Markierung, Finale und Auflösung bleiben StatelessWidgets (anklage.dart, finale.dart, aufloesung.dart).
  - 2 → Anklage (anklage.dart): vier Karten mit FarbPunkt, Name, Titel und „gespielt von“. Antippen markiert, „Anklagen“ öffnet die Bestätigung „Das ist endgültig“, „Ja“ ruft `sitzung.anklagen(p)` auf. Weiter ist vorher gesperrt. Danach ist der Knopf „Anklagen“ gesperrt.
  - 3 → Finale (finale.dart): Rückblende in einem abgerundeten Kasten, Höhe max(280 px; 55 % der Höhe). Überschrift `sitzung.ende.name`, darunter ErzaehlerFeld mit `sitzung.erzaehler`, Weiter.
  - 4 → Auflösung (aufloesung.dart): In der Auflösung je Baustein ein ErzaehlerFeld. Rollenbausteine haben Spielername und Farbpunkt, die Gruppenzeile steht zuerst ohne Namen. Im Ende: Abschlusstafel mit Ende, Punkten, Täter und Fall-Code samt Hinweis und Dank, ohne Weiter-Knopf. Der Rand ist grün bei richtiger, rot bei falscher Anklage.
  - 5 → ui-finale.json mit den Bausteinen (siehe unten).
  - 6 → finale_test.dart mit 13 Tests (siehe unten).
  - 7 → Testweg ausgeführt, alles grün, Fehler behoben (ein Test tippte außerhalb des Sichtbereichs, daraufhin auf die Sperre des Knopfes präzisiert).
- UI-BAUSTEINE: 22 Einträge. Präfixe: ui.anklage.* (10), ui.finale.* (2), ui.aufloesung.* (10).
- TESTS: 13 Tests (davon zwei Überlauf-Tests in einer Schleife). Letzte Zeile von `flutter test`: `00:03 +13: All tests passed!`
- ANALYSE: letzte Zeile von `flutter analyze` auf den vier Dart-Dateien: `No issues found! (ran in 3.9s)`
- TEXTE: letzte Zeile von `dart run bin/party_texte.dart`: `Texte: OK (1361 Texte)`. Zusätzlich: `dart test test/party/texte_test.dart test/party/textpruefer_test.dart` mit `All tests passed!`.
- GREP: Die Vorgabe-Prüfung auf sichtbaren Text im Code ergibt keine Treffer (Exit 1). Zusätzlich geprüft: Alle Zeichenketten-Literale in den drei Dateien sind Bausteinkennungen, Platzhalter-Schlüssel oder technische Werte (Kennungsteile „gruppe“ und „aufloesung“, Import-Pfade).

## OFFENE FRAGEN
- Das ErzaehlerFeld von F4-BAUMEISTER-05 ist im Repo noch in Arbeit. Meine Tests finden Erzählertexte als ganzen Text per `find.text`. Das passt zum Stand beim Lauf. Stellt das Feld den Text später Stück für Stück dar, müssen die Tests „Finale …“ und „Auflösung …“ angepasst werden.
- Zwei Bausteine gehen über die Vorgabe hinaus: `ui.finale.rueckblende` (Überschrift über dem Zeitraffer) und `ui.aufloesung.figur` („Figur: {name}“, nur wenn der Spielername anders ist). Bitte bestätigen oder streichen.
- Hinweis an ORCH und Kanon (nicht geändert): Ahmet (#1A1A1A) und Baran (#333333) sind auf dem dunklen Grund kaum zu sehen. Der Farbpunkt zeigt dort fast nur seinen Rahmen.
- Zum Vorgehen: Ich habe zu Beginn zweimal `git log` nur lesend benutzt, sonst nur `git status`. Am Repo habe ich nichts per Git geändert. Die Git-Änderungen anderer Baumeister habe ich nicht angefasst.

=== ENDE F4-BAUMEISTER-06 · BEREIT ZUR RÜCKGABE ===
