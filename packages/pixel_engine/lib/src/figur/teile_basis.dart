import 'figur.dart';

const _e = Form.ellipsoid, _q = Form.quader, _z = Form.zylinder;

/// Grundbibliothek der Figurenteile (Opus). Erweiterungen: `data/figuren/teile_*.json`
/// im selben Format (siehe FORMAT-FIGUREN.md).
final Map<String, Teil> kTeileBasis = {
  for (final t in <Teil>[
    // ---------------------------------------------------------------- Frisuren
    const Teil('frisur-kurz', 'frisur', [Grundkoerper(_e, 'kopf', [0, 0.145, -0.008], [0.104, 0.098, 0.108], 'haar')]),
    const Teil('frisur-stoppel', 'frisur', [Grundkoerper(_e, 'kopf', [0, 0.14, -0.01], [0.1, 0.092, 0.104], 'haar')]),
    const Teil('frisur-locken', 'frisur', [Grundkoerper(_e, 'kopf', [0, 0.14, -0.012], [0.124, 0.11, 0.124], 'haar')]),
    const Teil('frisur-schulterlang', 'frisur', [
      Grundkoerper(_e, 'kopf', [0, 0.145, -0.008], [0.106, 0.1, 0.11], 'haar'),
      Grundkoerper(_e, 'kopf', [0, 0.04, -0.035], [0.108, 0.125, 0.085], 'haar'),
    ]),
    const Teil('frisur-lang', 'frisur', [
      Grundkoerper(_e, 'kopf', [0, 0.145, -0.008], [0.106, 0.1, 0.11], 'haar'),
      Grundkoerper(_e, 'kopf', [0, -0.03, -0.05], [0.105, 0.21, 0.075], 'haar'),
    ]),
    const Teil('frisur-zopf', 'frisur', [
      Grundkoerper(_e, 'kopf', [0, 0.145, -0.008], [0.104, 0.098, 0.108], 'haar'),
      Grundkoerper(_e, 'kopf', [0, -0.06, -0.1], [0.034, 0.15, 0.034], 'haar', dreh: [12, 0, 0]),
    ]),
    const Teil('frisur-pferdeschwanz', 'frisur', [
      Grundkoerper(_e, 'kopf', [0, 0.145, -0.008], [0.104, 0.098, 0.108], 'haar'),
      Grundkoerper(_e, 'kopf', [0, 0.08, -0.125], [0.03, 0.11, 0.03], 'haar', dreh: [28, 0, 0]),
    ]),
    const Teil('frisur-dutt', 'frisur', [
      Grundkoerper(_e, 'kopf', [0, 0.145, -0.008], [0.104, 0.098, 0.108], 'haar'),
      Grundkoerper(_e, 'kopf', [0, 0.21, -0.07], [0.05, 0.045, 0.05], 'haar'),
    ]),
    const Teil('frisur-glatze', 'frisur', []),
    const Teil('frisur-haarkranz', 'frisur', [Grundkoerper(_e, 'kopf', [0, 0.1, -0.03], [0.106, 0.07, 0.1], 'haar')]),
    // ---------------------------------------------------------------- Bärte
    const Teil('bart-voll', 'gesicht', [Grundkoerper(_e, 'kopf', [0, 0.045, 0.05], [0.088, 0.072, 0.068], 'bart')]),
    const Teil('bart-kurz', 'gesicht', [Grundkoerper(_e, 'kopf', [0, 0.04, 0.06], [0.075, 0.05, 0.055], 'bart')]),
    const Teil('bart-schnurr', 'gesicht', [Grundkoerper(_e, 'kopf', [0, 0.078, 0.104], [0.042, 0.012, 0.016], 'bart')]),
    // ---------------------------------------------------------------- Oberteile
    const Teil('oberteil-strickjacke', 'oberteil', [
      Grundkoerper(_e, 'rumpf', [0, 0.2, 0], [0.174, 0.27, 0.112], 'oberteil'),
      Grundkoerper(_q, 'rumpf', [0, 0.27, 0.102], [0.034, 0.19, 0.018], 'darunter'),
    ]),
    const Teil('oberteil-mantel', 'oberteil', [
      Grundkoerper(_e, 'rumpf', [0, 0.24, 0], [0.178, 0.265, 0.118], 'oberteil'),
      Grundkoerper(_e, 'becken', [0, -0.17, 0], [0.18, 0.34, 0.13], 'oberteil'),
    ]),
    const Teil('oberteil-weste', 'oberteil', [Grundkoerper(_e, 'rumpf', [0, 0.23, 0.002], [0.172, 0.215, 0.113], 'weste')]),
    const Teil('oberteil-fleece', 'oberteil', [Grundkoerper(_z, 'rumpf', [0, 0.455, 0], [0.065, 0.03, 0.062], 'oberteil')]),
    const Teil('oberteil-hoodie', 'oberteil', [Grundkoerper(_e, 'kopf', [0, 0.03, -0.09], [0.105, 0.08, 0.065], 'oberteil')]),
    const Teil('oberteil-hemdkragen', 'oberteil', [Grundkoerper(_z, 'rumpf', [0, 0.45, 0.005], [0.06, 0.025, 0.06], 'darunter')]),
    const Teil('aermel-kurz', 'oberteil', [], umleitung: {'unterarm': 'haut'}),
    // ---------------------------------------------------------------- Unterteile
    const Teil('unterteil-rock', 'unterteil', [Grundkoerper(_e, 'becken', [0, -0.16, 0], [0.165, 0.25, 0.125], 'hose')], umleitung: {'unterbein': 'strumpf'}),
    const Teil('unterteil-kleid', 'unterteil', [Grundkoerper(_e, 'becken', [0, -0.2, 0], [0.17, 0.3, 0.13], 'oberteil')], umleitung: {'unterbein': 'strumpf', 'hose': 'oberteil'}),
    // ---------------------------------------------------------------- Schuhe
    const Teil('schuhe-stiefel', 'schuhe', [
      Grundkoerper(_z, 'knieL', [0, -0.36, 0], [0.066, 0.09, 0.07], 'schuhe'),
      Grundkoerper(_z, 'knieR', [0, -0.36, 0], [0.066, 0.09, 0.07], 'schuhe'),
    ]),
    // ---------------------------------------------------------------- Kopf
    const Teil('kopf-muetze', 'kopf', [Grundkoerper(_e, 'kopf', [0, 0.17, -0.005], [0.11, 0.088, 0.114], 'kopfbedeckung')]),
    const Teil('kopf-hut', 'kopf', [
      Grundkoerper(_z, 'kopf', [0, 0.2, 0], [0.16, 0.012, 0.16], 'kopfbedeckung'),
      Grundkoerper(_z, 'kopf', [0, 0.25, 0], [0.098, 0.055, 0.098], 'kopfbedeckung'),
    ]),
    const Teil('kopf-kappe', 'kopf', [
      Grundkoerper(_e, 'kopf', [0, 0.17, -0.005], [0.108, 0.08, 0.112], 'kopfbedeckung'),
      Grundkoerper(_q, 'kopf', [0, 0.165, 0.11], [0.075, 0.008, 0.05], 'kopfbedeckung'),
    ]),
    const Teil('kopf-haube', 'kopf', [Grundkoerper(_e, 'kopf', [0, 0.14, -0.02], [0.115, 0.115, 0.118], 'kopfbedeckung')]),
    // ---------------------------------------------------------------- Zubehör
    const Teil('brille', 'zubehoer', [Grundkoerper(_q, 'kopf', [0, 0.12, 0.106], [0.072, 0.013, 0.006], 'brille')]),
    const Teil('brille-stirn', 'zubehoer', [Grundkoerper(_q, 'kopf', [0, 0.19, 0.1], [0.072, 0.013, 0.008], 'brille', dreh: [-20, 0, 0])]),
    const Teil('schal', 'zubehoer', [
      Grundkoerper(_e, 'rumpf', [0, 0.46, 0.01], [0.095, 0.05, 0.09], 'schal'),
      Grundkoerper(_q, 'rumpf', [0.05, 0.34, 0.1], [0.026, 0.09, 0.012], 'schal'),
    ]),
    const Teil('rucksack', 'zubehoer', [Grundkoerper(_q, 'rumpf', [0, 0.27, -0.155], [0.12, 0.16, 0.06], 'tasche')]),
    const Teil('umhaengetasche', 'zubehoer', [Grundkoerper(_q, 'becken', [0.18, 0.02, 0.02], [0.03, 0.08, 0.09], 'tasche')]),
    const Teil('notizbuch', 'zubehoer', [Grundkoerper(_q, 'handL', [0, -0.07, 0.03], [0.036, 0.05, 0.009], 'papier')]),
    const Teil('laterne', 'zubehoer', [Grundkoerper(_z, 'handR', [0, -0.13, 0], [0.036, 0.055, 0.036], 'laterne')]),
    const Teil('handy', 'zubehoer', [Grundkoerper(_q, 'handR', [0, -0.05, 0.02], [0.02, 0.036, 0.005], 'handy')]),
    const Teil('kamera', 'zubehoer', [Grundkoerper(_q, 'rumpf', [0, 0.22, 0.13], [0.05, 0.035, 0.03], 'handy')]),
    // Signaturstücke aus dem Kanon (Inhaltsprüfung A-702i): breiter Gurt quer über die Brust
    // (vorn und hinten) und ein großer Kopfhörer um den Hals
    const Teil('kameragurt', 'zubehoer', [
      Grundkoerper(_q, 'rumpf', [0, 0.3, 0.118], [0.022, 0.2, 0.01], 'gurt', dreh: [0, 0, 38]),
      Grundkoerper(_q, 'rumpf', [0, 0.3, -0.118], [0.022, 0.2, 0.01], 'gurt', dreh: [0, 0, -38]),
    ]),
    const Teil('kopfhoerer', 'zubehoer', [
      Grundkoerper(_e, 'rumpf', [-0.072, 0.445, 0.06], [0.042, 0.046, 0.034], 'kopfhoerer'),
      Grundkoerper(_e, 'rumpf', [0.072, 0.445, 0.06], [0.042, 0.046, 0.034], 'kopfhoerer'),
      Grundkoerper(_q, 'rumpf', [0, 0.47, -0.04], [0.07, 0.012, 0.012], 'kopfhoerer'),
    ]),
  ])
    t.id: t,
};
