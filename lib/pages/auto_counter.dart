import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/web_socket_client.dart';

// Create a StateProvider
// for auto dispose, use StateProvider.autoDispose
// for non auto dispose, use StateProvider
final counterProvider = StreamProvider<int>((ref) {
  final client = ref.watch(webSocketClientProvider);
  return client.getCounterStream();
});

final webSocketClientProvider = Provider<WebSocketClient>((ref) {
  return FakeWebSocketClient();
});

class AutoCounterPage extends ConsumerWidget {
  const AutoCounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Counter'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // to reset the state
              // ref.refresh(counterProvider);
              // or
              ref.invalidate(counterProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Text(
          counter
              .when(
                data: (int val) => val,
                error: (Object e, _) => e,
                loading: () => 'loading ...',
              )
              .toString(),
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
