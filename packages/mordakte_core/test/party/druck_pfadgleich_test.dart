// F-14, E-008, E-036: Die offenen Druckteile verraten den Pfad nicht. Wer das
// Spielleitungsheft, den Detektivbogen, die Stimmkarten oder ein Kernrollen-Heft
// in der Hand hält, sieht in allen vier Pfaden dasselbe – bis auf die neutralen
// Codes und die Reihenfolge der Optionen, die am Fall-Code hängt.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/party_druck.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Das Spielleitungsheft ohne Codes: Bausteine und Schwellen.
Object _heft(Spielleitungsheft h) => [
      h.intro,
      h.rundenStart,
      h.resuemeeGruppe,
      h.resuemeeRest,
      h.resuemeeLage,
      h.anklage,
      [for (final a in h.auszaehlung) [for (final s in a.stufen) s.abSumme]],
      // Die Werte der Codetabelle als Menge: Welche Rolle −1 hat, steht nur auf den Karten.
      [for (final a in h.auszaehlung) (a.werte.values.toList()..sort())],
    ];

/// Der Detektivbogen ohne Codes: je Entscheidung Frage und die Menge der Optionstexte.
Object _bogen(List<BogenEntscheidung> b) => [
      for (final e in b) [e.id, e.frage, {for (final o in e.optionen) o.text}],
    ];

/// Die offenen Stimmkarten ohne Codes.
Object _stimmen(List<Stimmkarte> k) => [for (final s in k) [s.rolle, s.runde, s.a, s.text, s.wert]];

/// Das Rollenheft einer Kernrolle: Es zeigt Wer, Besetzung und Gespräche (Ziel und Wissen stehen in der Fassung).
Object _kernheft(Dossier d) => [
      d.wer,
      d.besetzung,
      for (final r in d.gespraeche.keys.toList()..sort())
        for (final (g, partner) in d.gespraeche[r]!) [g.id, g.thema, g.ziel, g.text, partner],
    ];

void main() {
  late Texte texte;
  setUpAll(() => texte = Texte(kanon, Textsammlung.lade((p) => leseJson('$repoWurzel/content/party/schlosskeller/$p'))));

  for (final n in [4, 7, 12, 20]) {
    test('Bei $n Rollen sind Spielleitungsheft, Detektivbogen, Stimmkarten und Kernrollen-Hefte in allen Pfaden gleich', () {
      final saetze = {
        for (final p in kanon.pfade) p: DruckSatz.aus(kanon, texte, FallCode.fuerPfad(p, kanon.pfade), rollen: n, detektiv: 'w'),
      };
      final ref = saetze[kanon.pfade.first]!;
      for (final MapEntry(key: p, value: s) in saetze.entries) {
        expect(_heft(s.spielleitung), _heft(ref.spielleitung), reason: '$n/$p: Spielleitungsheft');
        expect(_bogen(s.detektivbogen), _bogen(ref.detektivbogen), reason: '$n/$p: Detektivbogen');
        expect(_stimmen(s.stimmkarten), _stimmen(ref.stimmkarten), reason: '$n/$p: Stimmkarten');
        expect(s.besetzt, ref.besetzt, reason: '$n/$p: Besetzung');
        for (final k in kanon.kernverdaechtige) {
          expect(_kernheft(s.rollenhefte[k]!), _kernheft(ref.rollenhefte[k]!), reason: '$n/$p: Rollenheft $k');
        }
        // Fassungen: gleiche Rollen in gleicher Reihenfolge, je drei B-Streifen.
        expect([for (final f in s.fassungen) [f.rolle, f.streifen.keys.toList()]], [for (final f in ref.fassungen) [f.rolle, f.streifen.keys.toList()]]);
      }
    });
  }

  test('Rot-Probe: die alte Stimmkarte mit −1 beim Täter (vor E-036) wäre aufgefallen', () {
    final a = DruckSatz.aus(kanon, texte, FallCode.fuerPfad('ahmet', kanon.pfade), rollen: 7, detektiv: 'w');
    final b = DruckSatz.aus(kanon, texte, FallCode.fuerPfad('fatma', kanon.pfade), rollen: 7, detektiv: 'w');
    List<Stimmkarte> alt(DruckSatz s, String pfad) => [
          for (final k in s.stimmkarten) Stimmkarte(k.rolle, k.runde, k.a, k.text, !k.a && k.rolle == pfad ? -1 : k.wert, k.wertCode),
        ];
    expect(_stimmen(a.stimmkarten), _stimmen(b.stimmkarten));
    expect(_stimmen(alt(a, 'ahmet')), isNot(_stimmen(alt(b, 'fatma'))));
    // Ebenso die B-Streifen-Werte der Fassungen: Sie sind pfadabhängig und stehen deshalb nur versiegelt.
    expect([for (final f in a.fassungen) f.streifenWert], isNot([for (final f in b.fassungen) f.streifenWert]));
  });
}
