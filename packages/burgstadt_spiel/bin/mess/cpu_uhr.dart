import 'dart:ffi';
import 'dart:io';

/// Prozessorzeit des aufrufenden Threads in ms (Linux, nanosekundengenau); `null`, wenn nicht
/// verfügbar (kein Linux, libc nicht ladbar). Übernommen aus bin/leistung.dart (`_threadCpuUhr`).
/// libc direkt über dart:ffi – keine zusätzliche Abhängigkeit.
double Function()? threadCpuUhr() {
  if (!Platform.isLinux) return null;
  try {
    final libc = DynamicLibrary.process();
    final uhr = libc.lookupFunction<Int32 Function(Int32, Pointer<Int64>), int Function(int, Pointer<Int64>)>('clock_gettime');
    final speicher = libc.lookupFunction<Pointer<Int64> Function(IntPtr), Pointer<Int64> Function(int)>('malloc')(16);
    const threadCpu = 3; // CLOCK_THREAD_CPUTIME_ID
    if (uhr(threadCpu, speicher) != 0) return null;
    return () {
      uhr(threadCpu, speicher);
      return speicher[0] * 1e3 + speicher[1] / 1e6;
    };
  } catch (_) {
    return null;
  }
}
