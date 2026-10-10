# FÜR DEN NUTZER · Meta-Lauf BOLLWERK

## 1. Versehentlich angelegter Branch `bollwerk` (09.10.2026, ≈ 22:57 UTC) – bitte zur Kenntnis
- **Was:** Beim Schreiben eines Anhangs hat ein Shell-Heredoc ohne Anführungszeichen die Backticks im Text als Befehle ausgeführt. Einer davon war `git push origin HEAD:refs/heads/bollwerk`. Dadurch steht `origin/bollwerk` seit ≈ 22:57 UTC auf `f84715dab2780be406ea3f9596617a791e5014e4`.
- **Inhalt:** genau der damalige Stand von `bollwerk-plan` (origin/main 47611d8 plus nur `planung/bollwerk/**`). Kein Spielcode, keine Spieldaten, keine Einstellungsdatei.
- **Folge:** Der Meta-Lauf hat damit seine Grenze „nur `bollwerk-plan` pushen“ einmal verletzt. Er hat nichts gelöscht und nichts erneut versucht. `f84715d` ist Vorfahr jedes späteren `bollwerk-plan`-Stands; der Leitstand kann `bollwerk` beim Start von G1 per Fast-Forward auf den Übergabe-SHA setzen (`git push origin <übergabe-sha>:refs/heads/bollwerk`), ohne Force-Push.
- **Ursache und Gegenmaßnahme:** Genau die Lehre L-01 aus FEINKORN („keine Backticks in Heredocs“). Der Master-Prompt führt sie als harte Regel: Heredocs nur mit `<<'EOF'`; Texte mit Backticks werden mit Write geschrieben.

## 2. Was nur Menschen tun können
1. **Start freigeben:** Die Leitstand-Sitzung startet die Generationen nach dem STARTPAKET. Ein Mensch bestätigt einmal den Start. Pausen und Abbrüche laufen über `STOPP` bzw. Einträge in `STEUERUNG.md`.
2. **Annahmen kippen:** Jede Annahme A-01…A-25 lässt sich mit einer Zeile „A<n>: …“ in `STEUERUNG.md` ändern. Das gilt vor allem für A-01 (Design-Richtung), A-12 (HD-Linie), A-13 (technische Sperrdatei) und A-20 (Zielfaktor).
3. **Finalisierung abschließen:** PR #43 („Spuk im Schlosskeller“, Linie `finalisierung-schlosskeller`) prüfen und mergen. Erst danach trägt der Leitstand `B-02 ERFÜLLT · K=<sha>` ein, und der Hauptlauf beginnt. Bis dahin läuft nur der Vorlauf.
4. **Am Tisch spielen:** Spaß, Ton, Tempo und „fühlt sich der Würfel gut an?“ misst nur eine echte Runde mit Menschen. Empfohlen ist eine Partie nach Nacht 3 und eine vor MAIN-REIFE, mit Rückmeldung über STEUERUNG.
5. **Echte Geräte:** Leistung auf einem älteren Handy, WLAN im Heimnetz mit 3–5 Geräten und ein Probedruck des Druckspiels. Die Cloud prüft nur Browser, VM und Bilder.
6. **Bilder ansehen:** Der Leitstand zeigt nach jeder Nacht Kontaktbögen. Gefällt eine Richtung nicht, genügt „A1: R2“ oder ein Satz in STEUERUNG.
7. **main freigeben:** Bei MAIN-REIFE meldet der Leitstand einen Release-SHA R. Der Merge auf main geschieht nur nach menschlicher Freigabe.
8. **Branch `bollwerk` (§1):** Nichts zu tun, wenn der Leitstand ihn per Fast-Forward übernimmt. Wer ihn lieber löschen will, kann das nur von Hand tun.
9. **Kosten und Kontingent:** Die Nachtläufe nutzen Agenten im Umfang aus PLAN.md (Wellen zu 12, rund 61k Tokens je Einheit). Grenzen setzt nur der Mensch.

## G1 · Nachtlauf, Generation 1 (10.10.2026)

### G1-1 · Rohchat fehlt in der Cloud (zur Kenntnis)
`quellen/schlosskeller-teamchat.txt` liegt auf dieser Maschine nicht vor. Der Secret-Scan endet „sauber“, prüft aber die Passagen aus dem Rohchat nicht („Passagenprüfung übersprungen“). Übernommen wird nur, was die BOLLWERK-Läufe selbst geschrieben haben. Vor main braucht es einmal den Rohchat-Abgleich durch dich (Z-35).

### G1-2 · Frage: Weißlisten-Zusatzfunde (Z-11 verlangt ≥ 14)
- **Befund (L-4):** Der Kanon trägt sicher nur 10 pfadgleiche Zusatzfunde, mit `spur_handykorb` 11. Zwei Kandidaten des Meta-Laufs (Schneiders Erinnerung, Tims Gesicht) belasten nach dem Bericht den Täter Can.
- **Frage:** Dürfen Zusatzfunde auch **neue, pfadgleiche Kleinigkeiten der Schicht** sein (z. B. „Der Teekocher ist noch warm“), die nur Wahres über Dinge sagen, die in allen vier Fassungen gleich sind, und nie zur Lösung beitragen?
- **Standardwahl:** Ja, mit Kanonwächter-Prüfung je Fund; vorher prüft Opus die zwei Täter-Befunde nach.
- **Folge beim Kippen:** Ohne neue Funde bleibt Z-11 rot, bis „A<n>: ja“ das Pflichtziel auf 10 oder 11 senkt.

### G1-3 · Frage: Seifenblasen-Marken und „gründlich“ im Abstecher (Kern 1.1)
- **Befund (Prüfbericht PRUEF-KERN-1):** Der Meta-Simulator, nach dem die Würfelbänder gemessen wurden, vergibt eine Marke nur bei Pech in der Auftakt-Suche und lässt „gründlich“ im Abstecher nichts kosten. Der Spielkern (A-4 K-07, K-10) verlangt: jedes Pech bringt eine Marke, „gründlich“ kostet 2 Nachtminuten.
- **Standardwahl:** Der Spielkern gilt (Kern 1.1 in G2), die Bänder werden neu gemessen; liegen sie danach außerhalb, werden die Parameter nur innerhalb der Bänder nachgestellt (A-17).
- **Folge beim Kippen:** Nichts zu tun; das Spiel würde dann seltener Marken verteilen als beschrieben.

## G2 · Nachtlauf, Generation 2 (10.10.2026)

### G2-1 · Frage: HD-Linie der Burgstadt (A-12)
- **Befund:** Ein Probe-Merge der Linie `caf1d61` (Burgstadt HD: Hocker, Bänke, Tische, Licht) ändert 192 von 198 Burgstadt-Bildern des Migrationsbelegs. Konflikte gibt es keine.
- **Frage:** Soll die HD-Linie trotz geänderter Burgstadt-Bilder in BOLLWERK zusammengeführt werden („A12: ja“ in STEUERUNG)?
- **Standardwahl:** Nein – nur archiviert, Burgstadt bleibt bytegleich wie heute auf main.
- **Folge beim Kippen:** Merge in einer späteren Generation mit Phasentor und Vorher/Nachher-Bogen der Burgstadt.

### G2-2 · ABBRUCH der Generation 2 (bitte entscheiden)
- **Was geschah:** Ein Haiku-Agent (Abstecher Kaminsaal, Welle W2) hat einmal das Werkzeug `send_message` aufgerufen – mit leerer Eingabe. Die Plattform hat den Aufruf blockiert; es wurde keine Nachricht verschickt, nichts geändert. Schon vorher hatte ein anderer Haiku-Agent einmal ein lesendes Dokumentations-Werkzeug aufgerufen (Ergebnis verworfen).
- **Warum Abbruch:** Die harte Regel (A-2 A4.2, Master-Prompt §3) sagt: Ein Verstoß mit steuerndem Werkzeug ist ein Abbruchgrund – ohne Ausnahme für abgewehrte Aufrufe. Der Lauf hat sie deshalb befolgt, nachdem alles gesichert war.
- **Gesichert:** Kern 1.1 (Würfel nach dem Spielkern, neu gemessen, alles grün), Prüfwerkzeuge für die Variantenfabrik, Meta-Archiv, Befunde F-3…F-8 quittiert, 90 Rohvarianten und 60 Füllstücke im Repo (`planung/bollwerk/vorrat/roh/`).
- **Optionen:**
  1. **„A13: ja“** – der Leitstand legt die technische Sperrdatei an (nur `permissions.deny` für die Remote-, GitHub-, Dokument- und Steuerwerkzeuge der Unteragenten). Dann kann ein Agent diese Werkzeuge gar nicht erst aufrufen. **Empfehlung.**
  2. Neustart ohne Sperrdatei: Das Risiko bleibt (2 von 10 Haiku-Aufrufen griffen daneben), und der nächste solche Aufruf bricht wieder ab.
  3. Regeländerung „abgewehrte steuernde Aufrufe ohne Wirkung = verwerfen statt abbrechen“ – geht nur über dich, nicht über den Lauf (Grenzen ändert der Nachtlauf nie).
- **Danach:** Der Leitstand startet G3; sie setzt beim PRUEFPUNKT „Nächster Schritt“ an (Richter für Welle W1, Wiederholung der verworfenen Slots).
