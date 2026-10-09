/// Stadtbewohner der Oberstadt mit ihrem Nachtplan (`data/stadt/bewohner.json`).
/// Sie gehören nicht zum Fall: keine Hinweise, keine Gespräche aus dem Kanon –
/// sie machen die Stadt lebendig (schlafen, arbeiten, stehen in der Tür, streifen
/// durch ihr Viertel).
library;

class NachtEintrag {
  /// Minuten nach Mitternacht (wie `FallZustand.uhr`).
  final int von, bis;

  /// `wohnhaus`, `arbeitshaus`, `fenster` oder `gasse:<Viertel>`.
  final String wo;

  /// `wach`, `schläft`, `arbeitet`, `unterwegs`.
  final String zustand;
  final String tut;
  const NachtEintrag(this.von, this.bis, this.wo, this.zustand, this.tut);

  static int _minuten(String hhmm) {
    final t = hhmm.split(':');
    return int.parse(t[0]) * 60 + int.parse(t[1]);
  }

  factory NachtEintrag.ausJson(Map<String, dynamic> j) => NachtEintrag(
      _minuten(j['von'] as String), _minuten(j['bis'] as String), j['wo'] as String, j['zustand'] as String, j['tut'] as String);
}

class Bewohner {
  final String id, name, beruf, wohnhaus, arbeitshaus;
  final List<NachtEintrag> nacht;
  const Bewohner(this.id, this.name, this.beruf, this.wohnhaus, this.arbeitshaus, this.nacht);

  factory Bewohner.ausJson(Map<String, dynamic> j) => Bewohner(
        j['id'] as String,
        j['name'] as String,
        j['beruf'] as String? ?? '',
        j['wohnhaus'] as String? ?? '',
        j['arbeitshaus'] as String? ?? j['wohnhaus'] as String? ?? '',
        [for (final e in j['nacht'] as List) NachtEintrag.ausJson(e as Map<String, dynamic>)],
      );

  /// Index des Plan-Eintrags zur Uhrzeit [uhr] (Minuten); vor dem ersten gilt der
  /// erste, nach dem letzten der letzte.
  int eintragUm(double uhr) {
    for (var i = 0; i < nacht.length; i++) {
      if (uhr < nacht[i].bis) return i;
    }
    return nacht.length - 1;
  }

  String get vorname => name.split(' ').first;
}
