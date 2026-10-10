import 'glas_wachs.dart';
import 'holz_metall.dart';
import 'stein.dart';
import 'stoff_staub.dart';

/// Trägt alle Materialmuster in [kMuster] ein (einmal beim Start).
void registriereAlleMuster() {
  registriereStein();
  registriereHolzMetall();
  registriereGlasWachs();
  registriereStoffStaub();
}
