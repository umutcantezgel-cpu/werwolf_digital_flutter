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

- **Druck und Spoiler:** Wer das Druck-PDF absichtlich am Bildschirm durchliest, kann die versiegelten Täterfassungen lesen. Außen stehen nur neutrale Codes; vor dem Drucken sollte niemand aus der Runde das PDF durchblättern.

- **Gruppenwahl ohne Ergebnisanzeige (E-025):** Die Runde sieht nach ihrer Wahl nicht, ob der Hinweis wahr, neutral oder ein Gerücht war, und auch keine Stimmenzahl. Sonst ließe sich ein Gerücht als Freispruch lesen und die Sabotage der Täterrolle bei vier Rollen erkennen. Erst die Auflösung zeigt, wie oft die Gruppe zusammengehalten hat.
- **Wer mehrere Fall-Codes nacheinander spielt,** kann mit der Zeit lernen, welche Satzform der Hinweise in Runde 3 meist stimmt. Für einen Partyabend mit einem Fall ist das ohne Bedeutung.

## Optionen zur Entscheidung
- **Kernnamen:**
  - Laut Einstellungen bleiben Ahmet, Fatma, Olli und Can. Damit es keine Klischees gibt, sind Herkunft, Motive und Kopftuch so verteilt, dass keine Gruppe allein die Verfehlungen trägt (E-007).
  - Die Vorprüfung hatte zusätzlich vorgeschlagen, die Kernnamen über alle fünf Herkunftsgruppen neu zu verteilen. Wollt ihr das, ist es eine kleine Kanon-Änderung.

- **Kopftuch bei Fatma (E-014):**
  - Behzads Material gibt Fatma ein Kopftuch; sie ist zugleich eine der vier möglichen Täterinnen und hat die Münzschatulle mitgenommen.
  - Ich habe es behalten und Gegengewichte gesetzt: Ihr Motiv ist Ehrgeiz für ihre Abschlussarbeit, sie will die Schatulle zurückbringen. Aylin (Kopftuch) ist die kompetente Kassenprüferin, Emine (Kopftuch) Grundschullehrerin.
  - Wenn ihr es anders wollt, ist es eine Zeile im Kanon (`figuren.json`, Look von Fatma).
- **Herkunft:** Das Feld `herkunft` dient nur der Ausgewogenheitsprüfung. Es erscheint im Spiel nie als Etikett.

## Nur durch Menschen prüfbar
- Ein echter Testabend: Ton, Humor, Rundendauer (Vorgabe 30 Minuten), Verständlichkeit der Regeln.
- Die Wirkung der Figuren und der Bilder aus den Bildprompts.
- Die Stimme: welche lokale Stimme das Gerät anbietet und wie sie klingt.
- Ob sich die Gruppe in den Figuren wiederfindet.
