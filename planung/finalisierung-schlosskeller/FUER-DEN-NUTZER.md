# FÜR DEN NUTZER

Hier steht alles, was nur Menschen prüfen oder entscheiden können, und alles, was wegen der Grenzen weggelassen wurde. Die Liste wird bis F7 fortgeschrieben.

## Nicht übernommen, weil nicht vorhanden
- **Werkstatt („Ehrensache auf der Hebebühne“) und Gemeindesaal („Der letzte Tee im Gemeindesaal“):**
  - Im Repo gibt es dazu keine Daten oder Texte, nur die Titel im Teamchat. Es wurde nichts übernommen (E-006).
  - Das Kanon-Schema ist fallneutral (`content/party/<fall>/`), sodass beide Fälle später nach demselben Muster angelegt werden können.

## Grenzfälle, die ich so entschieden habe (bitte prüfen)
- **Flutter-SDK aus dem Netz:**
  - Zum Bauen und Testen habe ich Flutter 3.47.6 aus derselben Quelle geladen, die `build.sh` des Projekts verwendet (`storage.googleapis.com/flutter_infra_release/…/flutter_linux_3.47.6-stable.tar.xz`). Es liegt repo-lokal in `.werkzeug/flutter` und ist gitignored.
  - Ich werte das als Paketinstallation über das Werkzeug des Projekts (E-013, G2-2). Ohne SDK ließe sich kein Build und kein Test belegen.
- **CanvasKit:**
  - `build.sh` baut jetzt mit `--no-web-resources-cdn`. So lädt die Web-Fassung CanvasKit nicht mehr von `gstatic.com`, sondern aus dem eigenen Build.
  - Die Datei wird dadurch etwa 37 MB größer, wenn das Deployment den Ordner ausliefert. Das ist die Bedingung für „zur Laufzeit keine fremden Server“.
- **Spoilerschutz:** Wer im Browser die Entwicklerwerkzeuge öffnet, kann die Kanon-Dateien und damit die Lösung lesen. Das zu verhindern ist in einer lokalen Web-App nicht möglich und kein Ziel (E-013).

- **Druck und Spoiler (E-035):** Außen steht überall nur ein neutraler Code, auch auf den Fassungen; keine Seite verrät sich durch Zahl, Rahmen oder Überschrift. Wer beim Ausschneiden bewusst die Rückseiten liest, kann trotzdem Funde und die Täterfassung lesen. Druckt einseitig, sortiert nur nach Codes, und am besten druckt jemand, der nicht das Geburtstagskind ist.

- **Gruppenwahl ohne Ergebnisanzeige (E-025):** Die Runde sieht nach ihrer Wahl nicht, ob der Hinweis wahr, neutral oder ein Gerücht war, und auch keine Stimmenzahl. Sonst ließe sich ein Gerücht als Freispruch lesen und die Sabotage der Täterrolle bei vier Rollen erkennen. Erst die Auflösung zeigt, wie oft die Gruppe zusammengehalten hat.
- **Wer mehrere Fall-Codes nacheinander spielt,** kann mit der Zeit lernen, welche Satzform der Hinweise in Runde 3 meist stimmt. Für einen Partyabend mit einem Fall ist das ohne Bedeutung.

- **Helligkeit der Karte (Master 7.13):** Die Ermittlung zeigt das verlangte Grundlicht von 23 % in kühlem Blaugrau, dazu warme Kerzenpunkte und den Lichtkegel des Geburtstagskinds. Auf hellen Bildschirmen wirkt das stimmungsvoll; auf einem dunklen Beamer kann es zu düster sein. Der Wert ist eine Zahl in `lib/party/karte_session.dart` (`dunkel: 0.77`).
- **Erzählerstimme:** Sie nutzt nur Stimmen, die der Browser als lokal meldet, und liest genau den Bausteintext vor. Fehlt eine deutsche lokale Stimme, steht der Text da und ein Hinweis erscheint. Chrome kann sehr lange Sätze manchmal abbrechen; dann hilft „Noch einmal vorlesen“.
- **Stimmen auf Papier (E-036, E-039):** Die vier Kernrollen haben keine offenen Stimmkarten. Sie geben je Runde einen Streifen A oder B aus ihrer versiegelten Fassung ab; nur beim Täter zählt B −1. Die Spielleitung merkt beim Zählen, dass sabotiert wurde, aber nicht von wem, weil sie keinen Code einer Kernrolle kennt. Die Codes der Gäste stehen auf deren Karten; wer sie sich beim Ausschneiden merkt, wüsste, welcher Gast wie gestimmt hat. Am Bildschirm sieht das niemand.
- **Fassungen beim Falten (E-039):** Die Innenseite der Täterfassung ist dichter beschrieben als die drei anderen (etwa 450 gegen 250 Wörter), weil sie die Tat erzählt. Ganz gleich würde es nur mit Fülltext. Faltet die Fassungen deshalb genau so, wie das Spielleitungsheft es beschreibt, und seht dabei nicht hinein.
- **Kleine Runde und Sabotage (E-039):** Bei vier Rollen verhindert eine Sabotage der Täterrolle in dieser Runde den wahren Hinweis. Das ist gewollt: Die Täterrolle kann eine kleine Runde bremsen.
- **Mehrmals spielen (E-039):** Fünf der neun Entscheidungen sind in jedem Pfad richtig. Wer den Fall mit mehreren Fall-Codes spielt, kann lernen, welche Optionen meist stimmen, und kommt dann leichter auf Meister-Punkte. Für einen Abend mit einem Fall spielt das keine Rolle. Der Simulator nennt die beste feste Folge (`party_simulate`).

## Optionen zur Entscheidung
- **Kernnamen:**
  - Laut Einstellungen bleiben Ahmet, Fatma, Olli und Can. Damit es keine Klischees gibt, sind Herkunft, Motive und Kopftuch so verteilt, dass keine Gruppe allein die Verfehlungen trägt (E-007).
  - Die Vorprüfung hatte zusätzlich vorgeschlagen, die Kernnamen über alle fünf Herkunftsgruppen neu zu verteilen. Wollt ihr das, ist es eine kleine Kanon-Änderung.

- **Kopftuch bei Emine (E-039):** Emine trägt ein Kopftuch und hat gesehen, wie Fatma die Schatulle nahm; sie schweigt darüber. Sie hat weder Lüge noch Nebendelikt, die Regel aus TON §7 ist also eingehalten. Zwei der drei Kopftuchträgerinnen stehen damit aber im Schatulle-Strang. Wer das ändern will, legt Emines Kopftuch in `figuren.json` (Look `kopf`) auf eine andere, unbelastete Figur.
- **Kopftuch bei Fatma (E-014):**
  - Behzads Material gibt Fatma ein Kopftuch; sie ist zugleich eine der vier möglichen Täterinnen und hat die Münzschatulle mitgenommen.
  - Ich habe es behalten und Gegengewichte gesetzt: Ihr Motiv ist Ehrgeiz für ihre Abschlussarbeit, sie will die Schatulle zurückbringen. Emine (Kopftuch) ist Grundschullehrerin, Tugba (Kopftuch) die Geburtstags-Planerin, die beruflich Projekte leitet (E-029: das dritte Kopftuch lag zuerst bei Azra, damit standen alle drei Kopftuchträgerinnen im Schatulle-Strang).
  - Wenn ihr es anders wollt, ist es eine Zeile im Kanon (`figuren.json`, Look von Fatma).
- **Muster der Nebendelikte (SENS-03, E-029):**
  - Ahmet, Fatma und Can tragen Geld, Mitnahme der Schatulle und Streich, Olli Türschaden und Vertuschung. Wer die Namen türkisch oder muslimisch liest, kann darin ein Muster sehen.
  - Gegengewichte sind gesetzt: Jede Kernrolle ist gleich oft Täterin oder Täter, die Herkünfte sind verschieden, Fatma leiht die Schatulle zum Abzeichnen und will sie zurückbringen.
  - Zwei Auswege, je eine kleine Kanon-Änderung:
    - (1) Kernnamen neu verteilen, etwa Olli mit dem Mietgeld.
    - (2) Fatmas Kopftuch auf eine unbelastete Figur legen.
  - Ohne deine Entscheidung bleibt es, wie es ist.
- **Herkunft:** Das Feld `herkunft` dient nur der Ausgewogenheitsprüfung. Es erscheint im Spiel nie als Etikett.
  - Im Burgstadt-Strang habt ihr entschieden, dass Herkunft nicht Teil der Spieldaten ist (dort E48). Hier zeigt kein Spielertext eine Herkunft, nur die Story-Bibel und die Prüfwerkzeuge lesen das Feld.
  - Soll die Regel auch hier gelten, kommt das Feld aus `figuren.json` heraus und die Namensbalance wird über eine eigene Prüfliste belegt. Das ist eine kleine Änderung (E-028).
- **Farbnamen (E-028, E-037):** Fatma heißt jetzt „Beerenrot“ (Änderung aus dem Burgstadt-Strang). Tugba hieß zuerst „Bordeaux mit Gold“, dann „Karminrot mit Gold“, damit keine Farbe nach Wein klingt; seit E-037 trägt sie „Rostorange mit Gold“, weil Karminrot zu nah an Fatmas Beerenrot lag. Fatmas Kopftuch ist taubengrau.

## Nur durch Menschen prüfbar
- Ein echter Testabend: Ton, Humor, Rundendauer (Vorgabe 30 Minuten), Verständlichkeit der Regeln.
- Die Wirkung der Figuren und der Bilder aus den Bildprompts.
- Die Stimme: welche lokale Stimme das Gerät anbietet und wie sie klingt.
- Ob sich die Gruppe in den Figuren wiederfindet.
- Wie hell die Karte auf eurem Bildschirm oder Beamer wirken soll (siehe oben).
- Ob die Seifenblasen, der Staub an der Rüstung und die Rußwolke am Kamin witzig sind oder stören.
- **Die drei Lacher im Intro (E-039):** Olli verläuft sich, Sibel erschrickt vor der Rüstung, Hana verqualmt den Kamin. Fragt vorher, ob die Spielerinnen und Spieler dieser Rollen damit einverstanden sind. Die Lacher sind Vorgabe (TON §8); ändern lässt sich das in `texte/erzaehler-intro.json`.
- **Ähnliche Figurenfarben über Räume hinweg (E-037):** Meryem/Serkan, Olli/Serkan, Ahmet/Baran, Murat/Hakan, Olli/Meryem und Serkan/Kaan liegen unter ΔE 10. Im selben Startraum gilt überall mindestens 10. Die Figuren unterscheiden sich durch Silhouette, Kopf und Haar. Wer am Testabend Verwechslungen merkt, kann einzelne Farbcodes in `figuren.json` anpassen; der Farbtest zeigt dann sofort, ob die Abstände halten.
