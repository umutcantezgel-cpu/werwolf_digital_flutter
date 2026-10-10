/// Druckfassung als eigenständiges HTML: A4, Systemschriften, alles escaped.
///
/// Dieselben Ansichtsmodelle wie auf dem Bildschirm; jede Karte bricht nicht um.
library;

import 'ansichten.dart';
import 'gewoelbe.dart';
import 'texte.dart';

/// Escaped `&`, `<`, `>`, `"` und `'` für HTML; Zeilenumbrüche werden zu `<br>`.
String htmlText(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;')
    .replaceAll('\n', '<br>');

const _stil = '''
@page { size: A4; margin: 14mm; }
* { box-sizing: border-box; }
html { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
body { margin: 0; padding: 0; background: #ffffff; color: #22201E;
  font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  font-size: 10.5pt; line-height: 1.45; }
h1, h2, h3 { font-family: Georgia, "Times New Roman", serif; font-weight: 700; color: #22201E; }
h1 { font-size: 22pt; margin: 0 0 2mm; }
h2 { font-size: 14pt; margin: 0 0 2mm; }
h3 { font-size: 12pt; margin: 0; }
.untertitel { color: #6B6660; margin: 0 0 6mm; }
.kopfleiste { border-bottom: 2px solid #E8A33D; margin-bottom: 6mm; padding-bottom: 3mm; }
.raster { display: grid; grid-template-columns: 1fr 1fr; gap: 4mm; align-items: start; }
.karte { break-inside: avoid; page-break-inside: avoid; border: 1px solid #6B6660;
  border-left: 4px solid #E8A33D; border-radius: 2mm; padding: 3mm 4mm; margin: 0 0 4mm; background: #ffffff; }
.raster .karte { margin: 0; }
.kopf { display: flex; gap: 3mm; align-items: center; margin-bottom: 2mm; }
.initiale { flex: none; width: 10mm; height: 10mm; border-radius: 50%; background: #1E2A3A; color: #A9D6D9;
  display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 13pt; }
.aussprache { color: #6B6660; font-size: 9pt; }
.kopfzeile { color: #4A5A3C; font-size: 9.5pt; margin: 0 0 2mm; }
.eintrag { margin: 0 0 2mm; }
.label { display: block; font-size: 8pt; text-transform: uppercase; letter-spacing: 0.06em; color: #9C4A23; font-weight: 600; }
.punkt { margin: 0 0 1.5mm; padding-left: 4mm; text-indent: -4mm; }
.punkt::before { content: "· "; color: #C8642B; font-weight: 700; }
.punkt .label { display: inline; margin-right: 1.5mm; }
.hinweis { font-style: italic; color: #9C4A23; margin: 0 0 2mm; }
.zwischentitel { font-family: Georgia, "Times New Roman", serif; font-weight: 700; font-size: 11pt; color: #1E2A3A;
  border-bottom: 1px solid #E9DCC0; margin: 3mm 0 2mm; padding-bottom: 1mm; }
.block { margin-top: 3mm; }
.abschnitt { border-left: 4px solid #E8A33D; padding: 1mm 0 1mm 4mm; margin: 0 0 6mm; }
.abschnitt h2 { break-after: avoid; page-break-after: avoid; }
.neue-seite { break-before: page; page-break-before: always; }
.deckblatt { break-after: page; page-break-after: always; min-height: 240mm; display: flex; flex-direction: column;
  justify-content: center; align-items: center; text-align: center; border: 2px solid #22201E; padding: 20mm; }
.deckblatt .marke { font-size: 11pt; letter-spacing: 0.2em; text-transform: uppercase; color: #9C4A23; margin-bottom: 8mm; }
.deckblatt h1 { font-size: 30pt; }
.deckblatt .fuer { font-size: 16pt; margin-top: 10mm; }
@media screen { body { max-width: 190mm; margin: 0 auto; padding: 10mm 6mm; } }
''';

String _seite(String titel, String inhalt) =>
    '''<!doctype html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${htmlText(titel)}</title>
<style>$_stil</style>
</head>
<body>
$inhalt</body>
</html>
''';

/// Ein Eintrag als HTML.
String _eintrag(Eintrag e) {
  final label = e.label == null
      ? ''
      : '<span class="label">${htmlText(e.label!)}</span>';
  final block = e.block ? ' block' : '';
  return switch (e.art) {
    EintragArt.zwischentitel =>
      '<div class="zwischentitel$block">${htmlText(e.text)}</div>\n',
    EintragArt.hinweis =>
      '<p class="hinweis$block">$label${htmlText(e.text)}</p>\n',
    EintragArt.punkt =>
      '<p class="punkt$block">$label${htmlText(e.text)}</p>\n',
    EintragArt.absatz =>
      '<div class="eintrag$block">$label<div>${htmlText(e.text)}</div></div>\n',
  };
}

/// Ein Abschnitt als Karte; [ebene] ist die Überschriftsebene.
String _karte(Abschnitt a, {String klasse = 'karte', int ebene = 2}) {
  final b = StringBuffer();
  final seite = a.neueSeite ? ' neue-seite' : '';
  b.write('<section class="$klasse$seite">\n');
  if (a.initiale != null || a.untertitel != null) {
    b.write('<div class="kopf">');
    if (a.initiale != null) {
      b.write('<div class="initiale">${htmlText(a.initiale!)}</div>');
    }
    b.write('<div><h$ebene>${htmlText(a.titel)}</h$ebene>');
    if (a.untertitel != null) {
      b.write('<div class="aussprache">${htmlText(a.untertitel!)}</div>');
    }
    b.write('</div></div>\n');
  } else {
    b.write('<h$ebene>${htmlText(a.titel)}</h$ebene>\n');
  }
  if (a.kopfzeile != null) {
    b.write('<p class="kopfzeile">${htmlText(a.kopfzeile!)}</p>\n');
  }
  for (final e in a.eintraege) {
    b.write(_eintrag(e));
  }
  b.write('</section>\n');
  return b.toString();
}

/// „Steckbriefe für alle“ bei Besetzung [n]: Geburtstagskind, Burgwart, R01 … Rnn.
///
/// Enthält nur öffentliche Datensätze (Sicht `O`).
String steckbriefeHtml(Gewoelbe g, int n) {
  final karten = g.steckbriefe(n);
  final b = StringBuffer()
    ..write('<header class="kopfleiste">\n')
    ..write('<h1>${htmlText(GewoelbeTexte.titel)}</h1>\n')
    ..write(
      '<p class="untertitel">${htmlText(GewoelbeTexte.untertitel)} · '
      '${htmlText(GewoelbeTexte.druckSteckbriefe)} · '
      '${htmlText(GewoelbeTexte.personen(n))}</p>\n',
    )
    ..write('</header>\n')
    ..write('<div class="raster">\n');
  for (final k in karten) {
    final rolle = k.schluessel != 'DET' && k.schluessel != 'BW';
    b.write(_karte(k, klasse: rolle ? 'karte rolle' : 'karte', ebene: 3));
  }
  b.write('</div>\n');
  return _seite(GewoelbeTexte.htmlTitelSteckbriefe(n), b.toString());
}

/// Eine Rollenmappe als HTML: Deckblatt „Rollenmappe · Nur für …“, dann die
/// Abschnitte; jede Phase beginnt auf einer neuen Seite.
String mappeHtml(Mappe m) {
  final b = StringBuffer()
    ..write('<section class="deckblatt">\n')
    ..write(
      '<div class="marke">${htmlText(GewoelbeTexte.rollenmappe)} · '
      '${htmlText(GewoelbeTexte.nurFuer(m.name))}</div>\n',
    )
    ..write('<h1>${htmlText(GewoelbeTexte.titel)}</h1>\n')
    ..write('<p class="untertitel">${htmlText(GewoelbeTexte.untertitel)}</p>\n')
    ..write('<p class="fuer">${htmlText(m.name)}</p>\n')
    ..write('</section>\n');
  for (final a in m.abschnitte) {
    b.write(_karte(a, klasse: 'abschnitt'));
  }
  return _seite(GewoelbeTexte.htmlTitelMappe(m.name), b.toString());
}
