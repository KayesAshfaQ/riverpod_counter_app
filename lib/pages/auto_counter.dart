import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/web_socket_client.dart';

final webSocketClientProvider =
    Provider<WebSocketClient>((ref) => FakeWebSocketClient());

final counterProvider = StreamProvider.family<int, int>((ref, start) {
  final client = ref.watch(webSocketClientProvider);
  return client.getCounterStream(start);
});

class AutoCounterPage extends ConsumerWidget {
  const AutoCounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<int> counter = ref.watch(counterProvider(25));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Counter'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
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
