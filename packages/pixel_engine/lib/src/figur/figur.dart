/// Figuren-Baukasten: Skelett, Grundkörper, Teile, Figurenkarten, Animationen.
/// Format der Teile: `FORMAT-FIGUREN.md`. Einheiten: Meter, Winkel in Grad.
/// Figur-Raum: x = rechte Körperseite, y = oben, z = vorne (Blickrichtung).
library;

enum Form { ellipsoid, quader, zylinder }

/// Ein Grundkörper an einem Knochen.
class Grundkoerper {
  final Form form;
  final String knochen;
  final List<double> mitte; // relativ zum Knochenursprung
  final List<double> groesse; // Halbachsen
  final List<double> dreh; // Grad (x, y, z)
  final String material;

  const Grundkoerper(this.form, this.knochen, this.mitte, this.groesse, this.material, {this.dreh = const [0, 0, 0]});

  factory Grundkoerper.ausJson(Map<String, dynamic> j) => Grundkoerper(
        Form.values.byName(j['form'] as String),
        j['knochen'] as String,
        _vec(j['mitte']),
        _vec(j['groesse']),
        j['material'] as String,
        dreh: j['dreh'] == null ? const [0, 0, 0] : _vec(j['dreh']),
      );

  Map<String, Object> zuJson() => {
        'form': form.name,
        'knochen': knochen,
        'mitte': mitte,
        'groesse': groesse,
        if (dreh.any((d) => d != 0)) 'dreh': dreh,
        'material': material,
      };

  static List<double> _vec(Object? o) => [for (final v in o as List) (v as num).toDouble()];
}

/// Ein Teil (Frisur, Kleidungsstück, Zubehör): Grundkörper plus Material-Umleitungen
/// (z. B. kurze Ärmel: `unterarm → haut`).
class Teil {
  final String id;
  final String art; // koerper, frisur, kopf, oberteil, unterteil, schuhe, zubehoer, gesicht
  final List<Grundkoerper> koerper;
  final Map<String, String> umleitung;
  const Teil(this.id, this.art, this.koerper, {this.umleitung = const {}});

  factory Teil.ausJson(Map<String, dynamic> j) => Teil(
        j['id'] as String,
        j['art'] as String,
        [for (final k in (j['koerper'] as List? ?? const [])) Grundkoerper.ausJson(k as Map<String, dynamic>)],
        umleitung: {for (final e in ((j['umleitung'] as Map?) ?? const {}).entries) e.key as String: e.value as String},
      );
}

/// Material = Palettenrampe + Grundstufe (0–7). Schattierung nutzt Grundstufe −2…+1.
class Material {
  final int rampe;
  final int stufe;
  const Material(this.rampe, this.stufe);
}

/// Figurenkarte: alles, was eine Figur ausmacht (aus O-Datensätzen des Kanons
/// bzw. Bewohnerdaten).
class Figurenkarte {
  final String id;
  final String name;
  final double groesse; // Körpergröße in m (Kinder bis Erwachsene)
  final double breite; // Statur-Faktor (0.85 schmal … 1.25 kräftig)
  final double kopf; // Kopfgrößen-Faktor
  final Map<String, Material> materialien;
  final List<String> teile;

  const Figurenkarte({
    required this.id,
    required this.name,
    this.groesse = 1.75,
    this.breite = 1.0,
    this.kopf = 1.0,
    required this.materialien,
    required this.teile,
  });

  factory Figurenkarte.ausJson(Map<String, dynamic> j) => Figurenkarte(
        id: j['id'] as String,
        name: j['name'] as String,
        groesse: (j['groesse'] as num?)?.toDouble() ?? 1.75,
        breite: (j['breite'] as num?)?.toDouble() ?? 1.0,
        kopf: (j['kopf'] as num?)?.toDouble() ?? 1.0,
        materialien: {
          for (final e in (j['materialien'] as Map).entries)
            e.key as String: Material((e.value as List)[0] as int, (e.value as List)[1] as int),
        },
        teile: [for (final t in j['teile'] as List) t as String],
      );
}

/// Knochen des Skeletts (Ursprung relativ zum Elternknochen, für 1,75 m).
class Knochen {
  final String name;
  final String? eltern;
  final double x, y, z;
  const Knochen(this.name, this.eltern, this.x, this.y, this.z);
}

const List<Knochen> kSkelett = [
  Knochen('becken', null, 0, 0.95, 0),
  Knochen('rumpf', 'becken', 0, 0.06, 0),
  Knochen('kopf', 'rumpf', 0, 0.56, 0),
  Knochen('schulterL', 'rumpf', -0.19, 0.46, 0),
  Knochen('ellbogenL', 'schulterL', 0, -0.28, 0),
  Knochen('handL', 'ellbogenL', 0, -0.25, 0),
  Knochen('schulterR', 'rumpf', 0.19, 0.46, 0),
  Knochen('ellbogenR', 'schulterR', 0, -0.28, 0),
  Knochen('handR', 'ellbogenR', 0, -0.25, 0),
  Knochen('huefteL', 'becken', -0.095, -0.02, 0),
  Knochen('knieL', 'huefteL', 0, -0.45, 0),
  Knochen('fussL', 'knieL', 0, -0.44, 0),
  Knochen('huefteR', 'becken', 0.095, -0.02, 0),
  Knochen('knieR', 'huefteR', 0, -0.45, 0),
  Knochen('fussR', 'knieR', 0, -0.44, 0),
];

/// Pose: Drehung je Knochen (Grad) und Höhenversatz des Beckens (m).
class Pose {
  final Map<String, List<double>> dreh;
  final double hebung;
  const Pose(this.dreh, {this.hebung = 0});
}

/// Animationen (Name → Bilder). Gehen: 4 Bilder; Stehen: Atmen; Sprechen: Geste;
/// Untersuchen: Vorbeugen; Erschrecken: Arme hoch; Zeigen: Arm vor.
const Map<String, List<Pose>> kAnimationen = {
  'stehen': [
    Pose({'schulterL': [0, 0, -4], 'schulterR': [0, 0, 4]}),
    Pose({'schulterL': [0, 0, -5], 'schulterR': [0, 0, 5], 'rumpf': [-1, 0, 0]}, hebung: -0.012),
  ],
  'gehen': [
    Pose({'huefteL': [-24, 0, 0], 'knieL': [8, 0, 0], 'huefteR': [20, 0, 0], 'knieR': [14, 0, 0], 'schulterL': [18, 0, -4], 'schulterR': [-18, 0, 4], 'ellbogenL': [-10, 0, 0], 'ellbogenR': [-14, 0, 0]}),
    Pose({'huefteL': [-4, 0, 0], 'knieL': [4, 0, 0], 'huefteR': [6, 0, 0], 'knieR': [40, 0, 0], 'schulterL': [4, 0, -4], 'schulterR': [-4, 0, 4], 'ellbogenL': [-8, 0, 0], 'ellbogenR': [-8, 0, 0]}, hebung: 0.02),
    Pose({'huefteL': [20, 0, 0], 'knieL': [14, 0, 0], 'huefteR': [-24, 0, 0], 'knieR': [8, 0, 0], 'schulterL': [-18, 0, -4], 'schulterR': [18, 0, 4], 'ellbogenL': [-14, 0, 0], 'ellbogenR': [-10, 0, 0]}),
    Pose({'huefteL': [6, 0, 0], 'knieL': [40, 0, 0], 'huefteR': [-4, 0, 0], 'knieR': [4, 0, 0], 'schulterL': [-4, 0, -4], 'schulterR': [4, 0, 4], 'ellbogenL': [-8, 0, 0], 'ellbogenR': [-8, 0, 0]}, hebung: 0.02),
  ],
  'sprechen': [
    Pose({'schulterR': [-35, 0, 12], 'ellbogenR': [-60, 0, 0], 'schulterL': [0, 0, -5], 'kopf': [-4, 6, 0]}),
    Pose({'schulterR': [-45, 0, 18], 'ellbogenR': [-75, 0, 0], 'schulterL': [0, 0, -5], 'kopf': [3, -4, 0]}),
  ],
  'untersuchen': [
    Pose({'rumpf': [22, 0, 0], 'kopf': [16, 0, 0], 'schulterR': [-50, 0, 6], 'ellbogenR': [-20, 0, 0], 'schulterL': [-20, 0, -6], 'huefteL': [-12, 0, 0], 'huefteR': [-12, 0, 0], 'knieL': [16, 0, 0], 'knieR': [16, 0, 0]}, hebung: -0.04),
    Pose({'rumpf': [26, 0, 0], 'kopf': [20, 8, 0], 'schulterR': [-60, 0, 10], 'ellbogenR': [-10, 0, 0], 'schulterL': [-20, 0, -6], 'huefteL': [-14, 0, 0], 'huefteR': [-14, 0, 0], 'knieL': [20, 0, 0], 'knieR': [20, 0, 0]}, hebung: -0.05),
  ],
  'erschrecken': [
    Pose({'schulterL': [-20, 0, -70], 'schulterR': [-20, 0, 70], 'ellbogenL': [-70, 0, 0], 'ellbogenR': [-70, 0, 0], 'rumpf': [-8, 0, 0], 'kopf': [-8, 0, 0]}, hebung: 0.03),
    Pose({'schulterL': [-30, 0, -80], 'schulterR': [-30, 0, 80], 'ellbogenL': [-80, 0, 0], 'ellbogenR': [-80, 0, 0], 'rumpf': [-10, 0, 0], 'kopf': [-12, 0, 0]}, hebung: 0.05),
  ],
  'zeigen': [
    Pose({'schulterR': [-85, 0, 4], 'ellbogenR': [-5, 0, 0], 'schulterL': [0, 0, -5], 'kopf': [0, -6, 0]}),
  ],
};

/// Standard-Körper (wird jeder Figur vorangestellt). Materialien: haut, oberteil,
/// aermel, unterarm, hose, unterbein, schuhe.
const Teil kKoerper = Teil('koerper', 'koerper', [
  Grundkoerper(Form.ellipsoid, 'becken', [0, 0.03, 0], [0.15, 0.11, 0.10], 'hose'),
  Grundkoerper(Form.ellipsoid, 'rumpf', [0, 0.25, 0], [0.165, 0.25, 0.105], 'oberteil'),
  Grundkoerper(Form.ellipsoid, 'rumpf', [0, 0.47, -0.005], [0.05, 0.05, 0.05], 'haut'),
  Grundkoerper(Form.ellipsoid, 'kopf', [0, 0.11, 0.005], [0.098, 0.118, 0.105], 'haut'),
  Grundkoerper(Form.ellipsoid, 'schulterL', [0, -0.13, 0], [0.056, 0.16, 0.056], 'aermel'),
  Grundkoerper(Form.ellipsoid, 'ellbogenL', [0, -0.12, 0], [0.048, 0.14, 0.048], 'unterarm'),
  Grundkoerper(Form.ellipsoid, 'handL', [0, -0.03, 0.005], [0.036, 0.05, 0.03], 'haut'),
  Grundkoerper(Form.ellipsoid, 'schulterR', [0, -0.13, 0], [0.056, 0.16, 0.056], 'aermel'),
  Grundkoerper(Form.ellipsoid, 'ellbogenR', [0, -0.12, 0], [0.048, 0.14, 0.048], 'unterarm'),
  Grundkoerper(Form.ellipsoid, 'handR', [0, -0.03, 0.005], [0.036, 0.05, 0.03], 'haut'),
  Grundkoerper(Form.ellipsoid, 'huefteL', [0, -0.22, 0], [0.078, 0.25, 0.082], 'hose'),
  Grundkoerper(Form.ellipsoid, 'knieL', [0, -0.21, 0], [0.062, 0.24, 0.066], 'unterbein'),
  Grundkoerper(Form.ellipsoid, 'fussL', [0, -0.025, 0.045], [0.052, 0.04, 0.11], 'schuhe'),
  Grundkoerper(Form.ellipsoid, 'huefteR', [0, -0.22, 0], [0.078, 0.25, 0.082], 'hose'),
  Grundkoerper(Form.ellipsoid, 'knieR', [0, -0.21, 0], [0.062, 0.24, 0.066], 'unterbein'),
  Grundkoerper(Form.ellipsoid, 'fussR', [0, -0.025, 0.045], [0.052, 0.04, 0.11], 'schuhe'),
]);

/// Standard-Umleitungen fehlender Materialien.
const Map<String, String> kMaterialErsatz = {
  'aermel': 'oberteil',
  'unterarm': 'aermel',
  'unterbein': 'hose',
  'kragen': 'oberteil',
  'akzent': 'oberteil',
  'haar': 'haut',
  'bart': 'haar',
  'weste': 'oberteil',
  'darunter': 'oberteil',
  'kopfbedeckung': 'akzent',
  'tasche': 'akzent',
  'schal': 'akzent',
  'schuerze': 'akzent',
  'strumpf': 'haut',
};

/// Feste Materialien für Zubehör, falls die Karte keine eigenen nennt.
const Map<String, Material> kMaterialStandard = {
  'brille': Material(0, 1),
  'papier': Material(7, 7),
  'laterne': Material(4, 6),
  'handy': Material(0, 1),
  'metall': Material(0, 5),
};

/// Liest eine Teile-Datei (`{"version":1,"teile":[…]}`) – Format FORMAT-FIGUREN.md.
Map<String, Teil> teileAusJson(Map<String, dynamic> j) => {
      for (final t in j['teile'] as List) (t as Map<String, dynamic>)['id'] as String: Teil.ausJson(t),
    };
