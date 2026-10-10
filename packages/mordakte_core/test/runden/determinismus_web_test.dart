// L3 · gleiche Würfelprotokolle auf VM, Node und Chrome, gleich der eingecheckten Liste.
import 'package:test/test.dart';

import 'determinismus_lauf.dart';
import 'determinismus_soll.g.dart';

void main() {
  test('1.000 Codes: Protokoll-Summen gleich der Soll-Liste (WÜ-6)', () {
    final ist = determinismusListe(determinismusSoll.length);
    expect(ist.length, 1000);
    for (var i = 0; i < ist.length; i++) {
      expect(ist[i], determinismusSoll[i], reason: 'Code $i');
    }
  });
}
