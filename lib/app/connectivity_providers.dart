import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _connectivityProvider = Provider<Connectivity>((_) => Connectivity());

final connectivityProvider =
    StreamProvider<List<ConnectivityResult>>((ref) async* {
  final c = ref.watch(_connectivityProvider);
  // Emit current state right away so consumers don't sit in loading on cold start.
  yield await c.checkConnectivity();
  yield* c.onConnectivityChanged;
});

final isOfflineProvider = Provider<bool>((ref) {
  final results = ref.watch(connectivityProvider).valueOrNull;
  if (results == null || results.isEmpty) return false;
  return results.every((r) => r == ConnectivityResult.none);
});
