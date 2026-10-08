/// Ablage des Wiederverbindungs-Tokens: mobil in shared_preferences, im Web pro
/// Tab in `sessionStorage` (localStorage teilen sich alle Tabs – ein zweiter Tab
/// würde sonst den ersten mit `replaced` hinauswerfen und seinen Raum übernehmen).
library;

export 'token_store_io.dart' if (dart.library.js_interop) 'token_store_web.dart';
