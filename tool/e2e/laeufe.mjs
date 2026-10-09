// Laufliste des E2E-Gerüsts für den Partymodus (F4-BAUMEISTER-07).
// Je Pfad × Ende × Personenzahl ein Lauf (80). Fotos nur bei n = 7.
// Dazu je Pfad ein Semantik-Lauf mit ende_meister, n = 7, ohne Fotos (4).

export const PFADE = ['ahmet', 'fatma', 'olli', 'can'];

export const PERSONEN = [4, 7, 12, 16, 20];

/** Personenzahl, bei der Fotos gemacht werden. */
export const FOTO_PERSONEN = 7;

/** Skript je Ende: Entscheidungen, Gruppe, Anklage (Parameter `skript` des Entwickler-Einstiegs). */
export const ENDEN = {
  ende_meister: 'best,a,richtig',
  ende_teilerfolg: 'schlecht,a,richtig',
  ende_justizirrtum: 'best,a,falsch',
  ende_eskalation: 'schlecht,b,falsch',
};

function baueLaeufe() {
  const liste = [];
  for (const pfad of PFADE) {
    for (const ende of Object.keys(ENDEN)) {
      for (const n of PERSONEN) {
        liste.push({ pfad, ende, n, skript: ENDEN[ende], fotos: n === FOTO_PERSONEN, semantik: false });
      }
    }
  }
  return liste;
}

/** Die 80 Läufe. */
export const LAEUFE = baueLaeufe();

/** Die 4 Semantik-Läufe (je Pfad, ende_meister, n = 7, semantik=1, fotos=0). */
export const SEMANTIK_LAEUFE = PFADE.map((pfad) => ({
  pfad,
  ende: 'ende_meister',
  n: FOTO_PERSONEN,
  skript: ENDEN.ende_meister,
  fotos: false,
  semantik: true,
}));

if (LAEUFE.length !== 80 || SEMANTIK_LAEUFE.length !== 4) {
  throw new Error(`Laufliste unvollständig: ${LAEUFE.length} + ${SEMANTIK_LAEUFE.length}`);
}

/** Alle 84 Läufe in Reihenfolge: zuerst die 80, dann die Semantik-Läufe. */
export function alleLaeufe() {
  return [...LAEUFE, ...SEMANTIK_LAEUFE];
}
