import 'package:flutter/material.dart';
import 'package:flutter_application_1/liveness_state.dart';
import 'package:flutter_application_1/liveness_store.dart';

class LivenessResultWidget extends StatelessWidget {
  const LivenessResultWidget({
    Key? key,
    required LivenessStore livenessStore,
  })  : _livenessStore = livenessStore,
        super(key: key);

  final LivenessStore _livenessStore;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ValueListenableBuilder<LivenessState>(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Real: ${result?.real}"),
                  const Text("SessionId"),
                  Text("${result?.sessionId}"),
                  result?.image ??
                      const Text("Não foi possível carregar a imagem"),
                ],
              );
            }),
      ],
    );
  }
}
