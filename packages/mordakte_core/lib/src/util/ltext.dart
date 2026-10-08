/// Lokalisierter Text aus Szenario-JSON: `{"de": "...", "en": "..."}`.
class LText {
  final Map<String, String> values;

  const LText(this.values);

  static const empty = LText({});

  factory LText.fromJson(Object? json) {
    if (json == null) return empty;
    if (json is String) return LText({'de': json});
    if (json is Map) {
      return LText({
        for (final e in json.entries) e.key.toString(): e.value.toString(),
      });
    }
    throw FormatException('Ungültiger Text: $json');
  }

  Map<String, String> toJson() => values;

  bool get isEmpty => values.isEmpty;

  /// Text in [locale], sonst Deutsch, sonst irgendeine vorhandene Sprache.
  String resolve([String locale = 'de']) =>
      values[locale] ?? values['de'] ?? (values.isEmpty ? '' : values.values.first);

  @override
  String toString() => resolve();
}

/// Ersetzt `{name}`-Platzhalter in [template].
String fillTemplate(String template, Map<String, String> args) {
  if (args.isEmpty) return template;
  return template.replaceAllMapped(RegExp(r'\{(\w+)\}'), (m) {
    final key = m.group(1)!;
    return args[key] ?? m.group(0)!;
  });
}
