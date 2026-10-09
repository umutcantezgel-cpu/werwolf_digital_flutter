import 'dart:async';
import 'dart:js_interop';

import 'stimme.dart';

/// Stimme des Browsers über die Web Speech API (nur `dart:js_interop`, ohne Paket).
Stimme erzeugeStimme() => StimmeWeb();

/// Der Sprachsynthesizer des Browsers.
@JS('window.speechSynthesis')
external _Synthese get _synthese;

/// Die Teile von `speechSynthesis`, die das Feld braucht.
extension type _Synthese._(JSObject _) implements JSObject {
  external JSArray<_Stimme> getVoices();
  external void speak(_Aeusserung aeusserung);
  external void cancel();
}

/// Eine Äußerung (`SpeechSynthesisUtterance`).
@JS('SpeechSynthesisUtterance')
extension type _Aeusserung._(JSObject _) implements JSObject {
  external factory _Aeusserung(JSString text);
  external set voice(_Stimme? wert);
  external set lang(JSString wert);
  external set rate(JSNumber wert);
  external set onend(JSFunction<void Function()>? wert);
  external set onerror(JSFunction<void Function()>? wert);
}

/// Eine installierte Stimme (`SpeechSynthesisVoice`).
extension type _Stimme._(JSObject _) implements JSObject {
  external JSString get lang;
  external JSBoolean get localService;
}

/// Browser-Stimme: die erste lokale deutsche Stimme, sonst keine.
class StimmeWeb extends Stimme {
  /// Die erste lokale Stimme, deren Sprache mit „de“ beginnt.
  _Stimme? get _deutsch {
    try {
      for (final v in _synthese.getVoices().toDart) {
        if (v.localService.toDart && v.lang.toDart.startsWith('de')) return v;
      }
      return null;
    } catch (_) {
      // Kein Web Speech in diesem Browser: dann gibt es keine Stimme.
      return null;
    }
  }

  @override
  bool get verfuegbar => _deutsch != null;

  @override
  Future<bool> sprich(String text) {
    final stimme = _deutsch;
    if (stimme == null) return Future.value(false);
    final fertig = Completer<bool>();
    void ende(bool ok) {
      if (!fertig.isCompleted) fertig.complete(ok);
    }

    try {
      final aeusserung = _Aeusserung(text.toJS)
        ..voice = stimme
        ..lang = 'de-DE'.toJS
        ..rate = 0.95.toJS
        ..onend = (() => ende(true)).toJS
        ..onerror = (() => ende(false)).toJS;
      _synthese.speak(aeusserung);
    } catch (_) {
      ende(false);
    }
    return fertig.future;
  }

  @override
  void stopp() {
    try {
      _synthese.cancel();
    } catch (_) {
      // Ohne Web Speech ist nichts zu stoppen.
    }
  }
}
