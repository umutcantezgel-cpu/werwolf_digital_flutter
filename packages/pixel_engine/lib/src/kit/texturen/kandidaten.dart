import '../texturen.dart';

/// Textur-Kandidaten (Burgstadt HD): neue HD-Texturen und ★-Varianten vor der Wahl, nach Name.
/// Jede liegt in einer eigenen Datei `kit/texturen/<name>.dart`; ihr Autor trägt sie hier mit EINER
/// Zeile ein (Name `<textur>_<variante>`, z. B. `pflaster_a`). Der Orchestrator übernimmt die gewählte
/// Fassung in das Register (`texturen.dart`, HD-Fassungen nach [TexturId]) und streicht sie hier.
/// Kontaktbogen: `dart run bin/kontaktbogen.dart kandidaten <png> [namen]` (packages/burgstadt_spiel).
final Map<String, TexturEintrag> kTexturKandidaten = {
};
