import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werwolf_digital_flutter/services/haptic_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  test('HapticManager triggers platform selection', () async {
    await HapticManager().selection();
    expect(
        log,
        contains(isA<MethodCall>()
            .having((c) => c.method, 'method', 'HapticFeedback.vibrate')));
    // Precise method name for selectionClick might vary by flutter version or it maps to 'HapticFeedback.vibrate' with args
    // Actually, 'HapticFeedback.selectionClick' usually calls SystemChannels.platform.invokeMethod('HapticFeedback.vibrate', 'HapticFeedbackType.selectionClick')
    // Let's just check non-empty log or specific method if possible.
    expect(log, isNotEmpty);
    expect(log.last.method, 'HapticFeedback.vibrate');
  });

  test('HapticManager triggers heavy impact', () async {
    await HapticManager().impactHeavy();
    expect(log, isNotEmpty);
    expect(log.last.method, 'HapticFeedback.vibrate');
  });
}
