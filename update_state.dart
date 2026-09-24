import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('.jules/state.json');
  if (await file.exists()) {
    final content = await file.readAsString();
    final json = jsonDecode(content);

    // Get HEAD hash
    final result = await Process.run('git', ['rev-parse', 'HEAD']);
    final hash = result.stdout.toString().trim();

    json['epoch'] = 1;
    json['last_stable_commit'] = hash;
    json['active_feature_vector'] = 'OPTIMIZE_CODE_QUALITY';

    // Format JSON with 2 spaces
    final encoder = JsonEncoder.withIndent('  ');
    final newContent = encoder.convert(json);

    await file.writeAsString(newContent);
    print('Updated state.json');
  } else {
    print('state.json not found');
  }
}
