import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import '../kanon/kanon.dart';
import '../texte.dart';
import 'aufloesung.dart';
import 'karten.dart';
import 'modell.dart';
import 'rollen.dart';
import 'satz_stil.dart';
import 'spielleitung.dart';

/// Alles, was ein Druckteil zum Setzen braucht (F5). Texte kommen nur über
/// [text] und [ui] (Bausteine `ui.druck.*` in `texte/ui-druck-*.json`) oder aus
/// den Daten des [satz]; kein Druckteil erzeugt Text (F-11).
class DruckKontext {
  DruckKontext(this.kanon, this.texte, this.satz, this.stil);

  final Kanon kanon;
  final Texte texte;
  final DruckSatz satz;
  final DruckStil stil;

  String get fallTitel => kanon.fall['titel'] as String;

  String text(String kennung) => texte.baustein(kennung);

  String ui(String kennung, [Map<String, String> werte = const {}]) {
    var t = texte.baustein(kennung);
    for (final e in werte.entries) {
      t = t.replaceAll('{${e.key}}', e.value);
    }
    return t;
  }

  String figurName(String id) => kanon.figur(id)!['name'] as String;
  String figurTitel(String id) => (kanon.figur(id)!['roleTitle'] ?? '') as String;
}

/// Eine fertige PDF-Datei des Satzes. Der Dateiname trägt nur eine Nummer
/// und den Teil, nie einen Pfad oder eine Person.
class DruckDatei {
  final String name;
  final Uint8List bytes;
  const DruckDatei(this.name, this.bytes);
}

/// Setzt alle Teile des Druckspiels.
Future<List<DruckDatei>> druckDateien(DruckKontext k) async {
  Future<DruckDatei> datei(String name, String titel, void Function(pw.Document, DruckKontext) teil) async {
    final doc = k.stil.neuesDokument('${k.fallTitel} · $titel');
    teil(doc, k);
    return DruckDatei(name, await doc.save());
  }

  return [
    await datei('00-spielleitung.pdf', k.ui('ui.druck.datei.spielleitung'), spielleitungsheft),
    await datei('01-detektivbogen.pdf', k.ui('ui.druck.datei.detektivbogen'), detektivbogen),
    await datei('10-rollenhefte.pdf', k.ui('ui.druck.datei.rollenhefte'), rollenhefte),
    await datei('11-fassungen.pdf', k.ui('ui.druck.datei.fassungen'), fassungen),
    await datei('12-stimmkarten.pdf', k.ui('ui.druck.datei.stimmkarten'), stimmkarten),
    await datei('20-indizkarten.pdf', k.ui('ui.druck.datei.indizkarten'), indizkarten),
    await datei('21-umschlaege.pdf', k.ui('ui.druck.datei.umschlaege'), umschlaege),
    await datei('90-aufloesung-versiegelt.pdf', k.ui('ui.druck.datei.aufloesung'), aufloesungsheft),
  ];
}
