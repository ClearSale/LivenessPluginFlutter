// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:flutter_application_1/liveness_store.dart';
import 'package:flutter_application_1/widgets/liveness_actions_widget.dart';
import 'package:flutter_application_1/widgets/liveness_result_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CS Livenesss Exemplo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LivenessActionsWidget(livenessStore: _livenessStore),
          Expanded(
            child: LivenessResultWidget(livenessStore: _livenessStore),
          ),
        ],
      ),
    );
  }
}
