// L3 · gleiche Würfelprotokolle auf VM, Node und Chrome, gleich der eingecheckten Liste
// der geltenden Kern-Version (Kern 1.1, E-G2-01; die Liste zu Kern 1.0 bleibt unverändert liegen).
import 'package:test/test.dart';

import 'determinismus_lauf.dart';
import 'determinismus_soll_k11.g.dart';

void main() {
  test('1.000 Codes: Protokoll-Summen gleich der Soll-Liste (WÜ-6)', () {
    final ist = determinismusListe(determinismusSoll.length);
    expect(ist.length, 1000);
    for (var i = 0; i < ist.length; i++) {
      expect(ist[i], determinismusSoll[i], reason: 'Code $i');
    }
  });
}
