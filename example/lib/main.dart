// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cs_liveness_flutter_example/liveness_store.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MainScaffold()));
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late LivenessStore _livenessStore;
  @override
  void initState() {
    super.initState();
    _livenessStore = LivenessStore();
  }

  @override
  void dispose() {
    _livenessStore.dispose();
    super.dispose();
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ValueListenableBuilder<LivenessState>(
            valueListenable: _livenessStore,
            builder: (context, value, child) {
              if (value is LivenessInitialState) {
                return const SizedBox.shrink();
              }
              if (value is LivenessLoadingState) {
                return const CircularProgressIndicator.adaptive();
              } else if (value is LivenessErrorState) {
                return Text(value.error);
              }

              final result = (value as LivenessSuccessState).liveness;
              return Column(
                children: [
                  Text("Real: ${result?.real}"),
                  Text("SessionId: ${result?.sessionId}"),
                  result?.image ??
                      const Text("Não foi possível carregar a imagem"),
                ],
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CS Livenesss Exemplo')),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                _livenessStore.start();
              },
              child: const Text("Iniciar Captura"),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _showInfo(context);
              },
              child: const Text("Visualizar informações"),
            ),
          ),
        ],
      ),
    );
  }
}
