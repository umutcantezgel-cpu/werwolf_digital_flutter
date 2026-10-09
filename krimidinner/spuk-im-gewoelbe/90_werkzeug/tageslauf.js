export const meta = {
  name: 'krimidinner-tageslauf',
  description: 'Produktionstag: Haiku schreibt je Paket, Zählprüfung und Opus-Abnahme, bis zu zwei Reparaturrunden',
  phases: [{ title: 'Schreiben' }, { title: 'Abnahme' }, { title: 'Reparatur' }],
}
// Aufruf durch den Produktionsleiter: Workflow({scriptPath: '<dieser Pfad>', args: {ids: ['PROFIL-R01', …]}})
// Vorher: python3 90_werkzeug/bau.py --tag N [--charge b]  (baut 30_pakete/<ID>.r0.md)
// Danach: python3 90_werkzeug/freigabe.py <ID> <Runde> für jede Freigabe; Eskalationen schreibt der Produktionsleiter selbst.
const ROOT = '/home/user/werwolf_digital_flutter/krimidinner/spuk-im-gewoelbe'
const IDS = args.ids
const URTEIL = {
  type: 'object',
  properties: {
    urteil: { type: 'string', enum: ['FREIGEGEBEN', 'REPARIEREN', 'NEU'] },
    summe: { type: 'integer' },
    fundstellen: { type: 'integer' },
    codes: { type: 'array', items: { type: 'string' } },
    offene_fragen: { type: 'array', items: { type: 'string' } },
    kanon_rueckwirkung: { type: 'string' },
  },
  required: ['urteil', 'summe', 'fundstellen', 'codes', 'offene_fragen', 'kanon_rueckwirkung'],
}

const schreib = (id, r) => agent(
  `Du bist Textautor. Dein einziger Auftrag steht in der Datei ${ROOT}/30_pakete/${id}.r${r}.md. Lies sie vollständig, bevor du schreibst, und lies keine anderen Dateien. ` +
  `Führe den Auftrag genau aus. Schreibe deine vollständige Ausgabe (Formular, Selbstprüfung, Endmarke) mit dem Write-Werkzeug in die Datei ${ROOT}/40_rueckgaben/${id}.r${r}.md. ` +
  `Antworte danach nur mit der letzten Zeile deiner Ausgabe.`,
  { label: `schreib:${id}.r${r}`, phase: r === 0 ? 'Schreiben' : 'Reparatur', model: 'haiku' })

const abnahme = (id, r) => agent(
  `Lies ${ROOT}/20_vorlagen/ABNAHME.md und befolge es genau. Kennung ${id}, Runde ${r}. Paket: ${ROOT}/30_pakete/${id}.r${r}.md. Rückgabe: ${ROOT}/40_rueckgaben/${id}.r${r}.md. ` +
  `Führe zuerst die Zählprüfung aus: python3 ${ROOT}/90_werkzeug/zaehl.py ${id} ${r} — ihr Ergebnis fließt in B, F, G und H ein. ` +
  `Schreibe die Abnahme nach ${ROOT}/50_abnahmen/${id}.r${r}.md. ` +
  (r < 2 ? `Lautet dein Urteil nicht FREIGEGEBEN, baue danach den Reparaturauftrag: python3 ${ROOT}/90_werkzeug/bau.py ${id} --runde ${r + 1} . ` : '') +
  `Antworte mit den strukturierten Feldern (codes = Fehlercodes der Fundstellen).`,
  { label: `abnahme:${id}.r${r}`, phase: 'Abnahme', schema: URTEIL, effort: 'high' })

const lauf = async (id) => {
  const verlauf = []
  for (let r = 0; r <= 2; r++) {
    await schreib(id, r)
    const u = await abnahme(id, r)
    verlauf.push({ runde: r, ...u })
    if (u.urteil === 'FREIGEGEBEN') return { id, status: 'FREIGEGEBEN', runde: r, verlauf }
  }
  return { id, status: 'ESKALATION', verlauf }
}

return await parallel(IDS.map(id => () => lauf(id)))
