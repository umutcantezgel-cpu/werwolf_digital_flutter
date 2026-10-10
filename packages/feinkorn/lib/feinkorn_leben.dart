/// FEINKORN · Leben (BE-01, A-2 Definitionen): die einzige Tür von Spielcode zu FEINKORN.
/// Nur Physik, Starrkörper, Material, Schattenkarte und das Gelenkgerüst – Leben, kein Aufbau.
/// Nie exportiert: baueFigur, Gelenkweg, Blockkoerper, backeWolke, IsoAnsicht und der eigene
/// Zufall FeinZufall (WÜ-1: in Spiellogik verboten).
library;

export 'src/feinkorn/bewegung/skelett.dart';
export 'src/feinkorn/darstellung/schattenkarte.dart';
export 'src/feinkorn/daten/material.dart';
export 'src/feinkorn/physik/physikwelt.dart';
export 'src/feinkorn/physik/starrkoerper.dart' show Starrkoerper;
