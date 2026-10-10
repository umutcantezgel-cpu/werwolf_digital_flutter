import 'kanon/kanon.dart';

/// Eine Zeile der Herkunftsmatrix (TON §7, §10 Nr. 5): Was eine Figur trägt,
/// nach Herkunft. Das Feld `herkunft` erscheint nie im Spiel; nur diese Prüfung
/// und die Story-Bibel lesen es.
class HerkunftZeile {
  final String figur;
  final String herkunft;
  final bool kernrolle;
  final bool nebendelikt;
  final int luegen;
  final bool verschweigt;
  final bool kopftuch;
  const HerkunftZeile(this.figur, this.herkunft, this.kernrolle, this.nebendelikt, this.luegen, this.verschweigt, this.kopftuch);
}

/// Die Matrix aller Figuren in Besetzungsreihenfolge.
List<HerkunftZeile> herkunftsMatrix(Kanon kanon) {
  final verborgen = {
    for (final b in kanon.beobachtungen)
      if (b['kanal'] == 'verborgen') b['wer'] as String,
  };
  final figuren = [...kanon.figuren]..sort((a, b) => (a['besetzungsplatz'] as int).compareTo(b['besetzungsplatz'] as int));
  return [
    for (final f in figuren)
      HerkunftZeile(
        f['id'] as String,
        f['herkunft'] as String,
        kanon.kernverdaechtige.contains(f['id']),
        f['nebendelikt'] != null,
        (f['luegen'] as List? ?? const []).length,
        verborgen.contains(f['id']),
        (f['look'] as Map?)?['kopf'] == 'kopftuch',
      ),
  ];
}

/// Verstöße gegen „Keine Gruppe trägt allein die Verfehlungen“: Jede Art von
/// Verfehlung, die mindestens zwei Figuren tragen, verteilt sich auf mindestens
/// zwei Herkünfte; und mindestens eine Kopftuchträgerin ist ganz unbelastet.
List<String> herkunftsVerstoesse(List<HerkunftZeile> m) {
  final f = <String>[];
  final arten = <String, bool Function(HerkunftZeile)>{
    'Nebendelikt': (z) => z.nebendelikt,
    'Lüge': (z) => z.luegen > 0,
    'Verschweigen': (z) => z.verschweigt,
    'Nebendelikt einer Kernrolle': (z) => z.kernrolle && z.nebendelikt,
  };
  for (final a in arten.entries) {
    final traeger = m.where(a.value).toList();
    final herkuenfte = {for (final z in traeger) z.herkunft};
    if (traeger.length >= 2 && herkuenfte.length < 2) f.add('${a.key}: alle ${traeger.length} bei $herkuenfte');
  }
  final kopftuch = m.where((z) => z.kopftuch).toList();
  if (kopftuch.isNotEmpty && !kopftuch.any((z) => !z.nebendelikt && z.luegen == 0 && !z.verschweigt)) {
    f.add('Kopftuch: keine Trägerin ist unbelastet (${kopftuch.map((z) => z.figur).join(', ')})');
  }
  return f;
}
