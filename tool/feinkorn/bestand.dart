// FEINKORN · Bestandsprüfung (K-01, K-14): hält den Bestand der App als normiertes Textbild fest und
// vergleicht ihn mit der Messbasis. Erfasst wird nur, was der Bestandsschutz schützt: Abhängigkeiten der
// App (pubspec.yaml und aufgelöste Pakete aus pubspec.lock), App-Kennung und Versionsnummer, Build- und
// Signatur-Einstellungen, Store-sichtbare Namen, Berechtigungen und die Netzziele im Code.
//
// Aufruf aus dem Repo-Wurzelordner:
//   dart run tool/feinkorn/bestand.dart                 → Bestandsbild auf stdout
//   dart run tool/feinkorn/bestand.dart --schreibe P    → Bestandsbild nach P (Messbasis anlegen)
//   dart run tool/feinkorn/bestand.dart --vergleiche P  → Abweichungen gegen P, Exit 1 bei Abweichung
//
// Nur dart:io, keine Abhängigkeit.

import 'dart:convert';
import 'dart:io';

/// Dateien, deren Inhalt als Ganzes zum Build gehört (Prüfsumme über den normierten Text).
const _buildDateien = [
  'android/app/build.gradle.kts',
  'android/build.gradle.kts',
  'android/settings.gradle.kts',
  'android/gradle.properties',
  'android/gradle/wrapper/gradle-wrapper.properties',
  'android/app/src/main/AndroidManifest.xml',
  'android/app/src/debug/AndroidManifest.xml',
  'android/app/src/profile/AndroidManifest.xml',
  'ios/Runner.xcodeproj/project.pbxproj',
  'ios/Runner/Info.plist',
  'ios/Flutter/AppFrameworkInfo.plist',
  'ios/Flutter/Debug.xcconfig',
  'ios/Flutter/Release.xcconfig',
  'web/index.html',
  'web/manifest.json',
  'build.sh',
];

/// Quellordner, in denen nach Netzzielen gesucht wird.
const _codeOrdner = ['lib', 'packages/mordakte_core/lib', 'packages/pixel_engine/lib', 'packages/burgstadt_core/lib',
  'packages/burgstadt_spiel/lib', 'packages/room_host/lib'];

void main(List<String> args) {
  final bild = bestandsbild();
  if (args.isEmpty) {
    stdout.write(bild);
    return;
  }
  if (args.length != 2 || (args[0] != '--schreibe' && args[0] != '--vergleiche')) {
    stderr.writeln('Aufruf: dart run tool/feinkorn/bestand.dart [--schreibe <datei> | --vergleiche <datei>]');
    exit(2);
  }
  final datei = File(args[1]);
  if (args[0] == '--schreibe') {
    datei.parent.createSync(recursive: true);
    datei.writeAsStringSync(bild);
    stdout.writeln('BESTAND geschrieben · ${bild.split('\n').length - 1} Zeilen · ${datei.path}');
    return;
  }
  if (!datei.existsSync()) {
    stderr.writeln('Messbasis fehlt: ${datei.path}');
    exit(2);
  }
  final alt = datei.readAsStringSync().split('\n').toSet();
  final neu = bild.split('\n').toSet();
  final weg = alt.difference(neu).where((z) => z.isNotEmpty).toList()..sort();
  final dazu = neu.difference(alt).where((z) => z.isNotEmpty).toList()..sort();
  for (final z in weg) {
    stdout.writeln('- $z');
  }
  for (final z in dazu) {
    stdout.writeln('+ $z');
  }
  final ok = weg.isEmpty && dazu.isEmpty;
  stdout.writeln('BESTANDSPRÜFUNG · ${ok ? 'GLEICH' : 'ABWEICHUNG'} · entfernt ${weg.length} · neu ${dazu.length}');
  if (!ok) exitCode = 1;
}

/// Das normierte Bestandsbild: je Zeile `bereich · schlüssel · wert`, sortiert innerhalb der Bereiche.
String bestandsbild() {
  final out = StringBuffer();
  void zeilen(String bereich, Iterable<String> werte) {
    for (final w in (werte.toList()..sort())) {
      out.writeln('$bereich · $w');
    }
  }

  final pubspec = File('pubspec.yaml').readAsLinesSync();
  zeilen('abhaengigkeit', _abhaengigkeiten(pubspec, 'dependencies'));
  zeilen('dev-abhaengigkeit', _abhaengigkeiten(pubspec, 'dev_dependencies'));
  zeilen('version', [for (final z in pubspec) if (z.startsWith('version:')) z.substring(8).trim()]);
  zeilen('name', [for (final z in pubspec) if (z.startsWith('name:')) z.substring(5).trim()]);
  zeilen('paket-aufgeloest', _lock(File('pubspec.lock')));
  for (final p in Directory('packages').listSync().whereType<Directory>().map((d) => d.path).toList()..sort()) {
    final f = File('$p/pubspec.yaml');
    if (!f.existsSync()) continue;
    zeilen('paket-abhaengigkeit $p', _abhaengigkeiten(f.readAsLinesSync(), 'dependencies'));
  }

  final gradle = _lies('android/app/build.gradle.kts');
  zeilen('android-kennung', [
    for (final m in RegExp(r'(applicationId|namespace)\s*=\s*"([^"]+)"').allMatches(gradle)) '${m[1]} ${m[2]}',
  ]);
  zeilen('android-signatur', [
    for (final z in gradle.split('\n'))
      if (RegExp(r'signingConfig|storeFile|keyAlias|storePassword|keyPassword').hasMatch(z)) z.trim(),
  ]);
  final manifeste = [for (final d in _buildDateien) if (d.endsWith('AndroidManifest.xml')) d];
  zeilen('android-berechtigung', [
    for (final d in manifeste)
      for (final m in RegExp(r'<uses-permission[^>]*android:name="([^"]+)"').allMatches(_lies(d))) '$d ${m[1]}',
  ]);
  zeilen('android-name', [
    for (final m in RegExp(r'android:label="([^"]+)"').allMatches(_lies('android/app/src/main/AndroidManifest.xml'))) m[1]!,
  ]);
  final pbx = _lies('ios/Runner.xcodeproj/project.pbxproj');
  zeilen('ios-kennung', {
    for (final m in RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);').allMatches(pbx)) m[1]!.trim(),
  });
  zeilen('ios-signatur', {
    for (final m in RegExp(r'(DEVELOPMENT_TEAM|CODE_SIGN_[A-Z_]+|PROVISIONING_PROFILE[A-Z_]*)(\[[^\]]*\])? = ([^;]+);').allMatches(pbx))
      '${m[1]} ${m[3]!.trim()}',
  });
  final plist = _lies('ios/Runner/Info.plist');
  zeilen('ios-berechtigung', {
    for (final m in RegExp(r'<key>(NS[A-Za-z]+UsageDescription|UIBackgroundModes|NSAppTransportSecurity)</key>').allMatches(plist)) m[1]!,
  });
  zeilen('ios-name', {
    for (final m in RegExp(r'<key>(CFBundleDisplayName|CFBundleName)</key>\s*<string>([^<]*)</string>').allMatches(plist)) '${m[1]} ${m[2]}',
  });
  final entitlements = Directory('ios').existsSync()
      ? Directory('ios').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.entitlements')).map((f) => f.path).toList()
      : <String>[];
  zeilen('ios-entitlements', [for (final e in entitlements) '$e ${_pruefsumme(_lies(e))}']);
  zeilen('build-datei', [
    for (final d in _buildDateien)
      if (File(d).existsSync()) '$d ${_pruefsumme(_lies(d))}' else '$d fehlt',
  ]);
  zeilen('netzziel', _netzziele());
  return out.toString();
}

String _lies(String pfad) => File(pfad).existsSync() ? File(pfad).readAsStringSync() : '';

/// Einfache, stabile Prüfsumme (FNV-1a 64 Bit über die UTF-8-Bytes, Zeilenenden normiert).
String _pruefsumme(String text) {
  var h = 0xcbf29ce484222325;
  for (final b in utf8.encode(text.replaceAll('\r\n', '\n'))) {
    h ^= b;
    h = (h * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
  }
  // Als zwei 32-Bit-Hälften, weil int 64 Bit mit Vorzeichen hat.
  final hoch = (h >> 32) & 0xFFFFFFFF, tief = h & 0xFFFFFFFF;
  return hoch.toRadixString(16).padLeft(8, '0') + tief.toRadixString(16).padLeft(8, '0');
}

/// Einträge unter `dependencies:` bzw. `dev_dependencies:` (eine Ebene, mit Version oder Quelle).
List<String> _abhaengigkeiten(List<String> zeilen, String abschnitt) {
  final out = <String>[];
  var drin = false;
  String? name;
  for (final z in zeilen) {
    if (z.trim().isEmpty || z.trimLeft().startsWith('#')) continue;
    if (!z.startsWith(' ')) {
      drin = z.trim() == '$abschnitt:';
      name = null;
      continue;
    }
    if (!drin) continue;
    final m2 = RegExp(r'^  ([A-Za-z0-9_]+):\s*(.*)$').firstMatch(z);
    if (m2 != null) {
      name = m2[1];
      final wert = m2[2]!.trim();
      if (wert.isNotEmpty) out.add('$name $wert');
      continue;
    }
    final m4 = RegExp(r'^    ([a-z_]+):\s*(.*)$').firstMatch(z);
    if (m4 != null && name != null) out.add('$name ${m4[1]}=${m4[2]!.trim()}');
  }
  return out;
}

/// Aufgelöste Pakete aus pubspec.lock: Name, Version, Quelle, Art (direct main / transitive …).
List<String> _lock(File f) {
  if (!f.existsSync()) return ['pubspec.lock fehlt'];
  final out = <String>[];
  String? name, version, quelle, art;
  void fertig() {
    if (name != null) out.add('$name $version $quelle $art');
  }
  var inPaketen = false;
  for (final z in f.readAsLinesSync()) {
    if (z.startsWith('packages:')) {
      inPaketen = true;
      continue;
    }
    if (!z.startsWith(' ')) {
      if (inPaketen) fertig();
      inPaketen = false;
      name = null;
      continue;
    }
    if (!inPaketen) continue;
    final kopf = RegExp(r'^  ([A-Za-z0-9_]+):$').firstMatch(z);
    if (kopf != null) {
      fertig();
      name = kopf[1];
      version = quelle = art = '';
      continue;
    }
    final m = RegExp(r'^    (dependency|source|version):\s*"?([^"]*)"?$').firstMatch(z);
    if (m != null) {
      switch (m[1]) {
        case 'dependency':
          art = m[2];
        case 'source':
          quelle = m[2];
        case 'version':
          version = m[2];
      }
    }
  }
  fertig();
  return out;
}

/// Netzziele im Code: Schema und Host aus http(s)/ws(s)-Literalen (ohne Kommentare und Beispiele in Doku).
Set<String> _netzziele() {
  final out = <String>{};
  final re = RegExp(r'''(https?|wss?)://([A-Za-z0-9.\-]+|\$\{?[A-Za-z_]+\}?)''');
  for (final o in _codeOrdner) {
    final d = Directory(o);
    if (!d.existsSync()) continue;
    for (final f in d.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'))) {
      // Zeilennummern bewusst nicht im Bild: verschobene Zeilen sind keine Abweichung.
      for (final z in f.readAsLinesSync()) {
        final t = z.trimLeft();
        if (t.startsWith('//')) continue;
        for (final m in re.allMatches(z)) {
          out.add('${m[1]}://${m[2]} ${f.path}');
        }
      }
    }
  }
  return out;
}
