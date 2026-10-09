/// Kleiner JSON-Schema-Prüfer für den Kanon (Teilmenge von Draft 2020-12).
///
/// Unterstützt: `type` (auch als Liste), `required`, `properties`,
/// `additionalProperties` (bool oder Schema), `items`, `enum`, `const`,
/// `pattern`, `minLength`, `minItems`, `maxItems`, `minimum`, `maximum`,
/// `anyOf`, `uniqueItems` und lokale Verweise `$ref: "#/$defs/<name>"`.
/// Mehr braucht der Kanon nicht; eine fremde Abhängigkeit ist so vermeidbar.
class SchemaPruefer {
  final Map<String, Object?> wurzel;

  SchemaPruefer(this.wurzel);

  /// Liefert alle Verstöße als `Pfad: Meldung`. Leer heißt gültig.
  List<String> pruefe(Object? daten) {
    final fehler = <String>[];
    _pruefe(wurzel, daten, r'$', fehler);
    return fehler;
  }

  void _pruefe(Map<String, Object?> s, Object? d, String pfad, List<String> f) {
    final ref = s[r'$ref'];
    if (ref is String) {
      _pruefe(_aufloesen(ref), d, pfad, f);
      return;
    }
    final anyOf = s['anyOf'];
    if (anyOf is List) {
      final passt = anyOf.any((alt) {
        final teil = <String>[];
        _pruefe((alt as Map).cast<String, Object?>(), d, pfad, teil);
        return teil.isEmpty;
      });
      if (!passt) f.add('$pfad: passt zu keiner Alternative');
    }
    final typ = s['type'];
    if (typ != null) {
      final typen = typ is List ? typ.cast<String>() : [typ as String];
      if (!typen.any((t) => _istTyp(t, d))) {
        f.add('$pfad: erwartet ${typen.join('|')}, gefunden ${_typName(d)}');
        return;
      }
    }
    if (s.containsKey('const') && !_gleich(s['const'], d)) {
      f.add('$pfad: erwartet ${s['const']}');
    }
    final en = s['enum'];
    if (en is List && !en.any((e) => _gleich(e, d))) {
      f.add('$pfad: "$d" nicht erlaubt (erlaubt: ${en.join(', ')})');
    }
    if (d is String) {
      final pat = s['pattern'];
      if (pat is String && !RegExp(pat).hasMatch(d)) f.add('$pfad: "$d" passt nicht zu /$pat/');
      final minL = s['minLength'];
      if (minL is int && d.length < minL) f.add('$pfad: kürzer als $minL Zeichen');
    }
    if (d is num) {
      final min = s['minimum'];
      if (min is num && d < min) f.add('$pfad: kleiner als $min');
      final max = s['maximum'];
      if (max is num && d > max) f.add('$pfad: größer als $max');
    }
    if (d is List) {
      final minI = s['minItems'];
      if (minI is int && d.length < minI) f.add('$pfad: weniger als $minI Einträge');
      final maxI = s['maxItems'];
      if (maxI is int && d.length > maxI) f.add('$pfad: mehr als $maxI Einträge');
      if (s['uniqueItems'] == true) {
        final gesehen = <String>{};
        for (final e in d) {
          if (!gesehen.add(e.toString())) f.add('$pfad: doppelter Eintrag $e');
        }
      }
      final items = s['items'];
      if (items is Map) {
        for (var i = 0; i < d.length; i++) {
          _pruefe(items.cast<String, Object?>(), d[i], '$pfad[$i]', f);
        }
      }
    }
    if (d is Map) {
      final req = s['required'];
      if (req is List) {
        for (final k in req) {
          if (!d.containsKey(k)) f.add('$pfad: Pflichtfeld "$k" fehlt');
        }
      }
      final props = (s['properties'] as Map?)?.cast<String, Object?>() ?? const {};
      final extra = s['additionalProperties'];
      for (final e in d.entries) {
        final k = e.key as String;
        final ps = props[k];
        if (ps is Map) {
          _pruefe(ps.cast<String, Object?>(), e.value, '$pfad.$k', f);
        } else if (extra == false) {
          f.add('$pfad: unbekanntes Feld "$k"');
        } else if (extra is Map) {
          _pruefe(extra.cast<String, Object?>(), e.value, '$pfad.$k', f);
        }
      }
    }
  }

  Map<String, Object?> _aufloesen(String ref) {
    const prefix = r'#/$defs/';
    if (!ref.startsWith(prefix)) throw FormatException('Nur lokale Verweise erlaubt: $ref');
    final defs = (wurzel[r'$defs'] as Map?)?.cast<String, Object?>();
    final ziel = defs?[ref.substring(prefix.length)];
    if (ziel is! Map) throw FormatException('Unbekannter Verweis: $ref');
    return ziel.cast<String, Object?>();
  }

  static bool _istTyp(String t, Object? d) => switch (t) {
        'object' => d is Map,
        'array' => d is List,
        'string' => d is String,
        'integer' => d is int || (d is double && d == d.roundToDouble()),
        'number' => d is num,
        'boolean' => d is bool,
        'null' => d == null,
        _ => throw FormatException('Unbekannter Schematyp: $t'),
      };

  static String _typName(Object? d) => switch (d) {
        null => 'null',
        Map() => 'object',
        List() => 'array',
        String() => 'string',
        int() => 'integer',
        double() => 'number',
        bool() => 'boolean',
        _ => d.runtimeType.toString(),
      };

  static bool _gleich(Object? a, Object? b) => a.toString() == b.toString() && _typName(a) == _typName(b);
}
