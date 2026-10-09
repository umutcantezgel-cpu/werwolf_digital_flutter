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

## Optionen zur Entscheidung
- **Kernnamen:**
  - Laut Einstellungen bleiben Ahmet, Fatma, Olli und Can. Damit es keine Klischees gibt, sind Herkunft, Motive und Kopftuch so verteilt, dass keine Gruppe allein die Verfehlungen trägt (E-007).
  - Die Vorprüfung hatte zusätzlich vorgeschlagen, die Kernnamen über alle fünf Herkunftsgruppen neu zu verteilen. Wollt ihr das, ist es eine kleine Kanon-Änderung.

## Nur durch Menschen prüfbar
- Ein echter Testabend: Ton, Humor, Rundendauer (Vorgabe 30 Minuten), Verständlichkeit der Regeln.
- Die Wirkung der Figuren und der Bilder aus den Bildprompts.
- Die Stimme: welche lokale Stimme das Gerät anbietet und wie sie klingt.
- Ob sich die Gruppe in den Figuren wiederfindet.
