// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cs_liveness_flutter/cs_liveness_flutter.dart';
import 'package:cs_liveness_flutter/cs_liveness_result.dart';
import 'package:flutter/material.dart';

abstract class LivenessState {}

class LivenessInitialState extends LivenessState {}

class LivenessLoadingState extends LivenessState {
  final bool _loading;

  LivenessLoadingState(this._loading);

  get loading => _loading;
}

class LivenessSuccessState extends LivenessState {
  final CsLivenessResult? _result;
  LivenessSuccessState(this._result);
  get liveness => _result;
}

class LivenessErrorState extends LivenessState {
  final String _error;
  LivenessErrorState(
    this._error,
  );

  get error => _error;
}

class LivenessStore extends ValueNotifier<LivenessState> {
  static const String clientId = "accurate";
  static const String clientSecret = "hmr5YqXy7yCJyVD1gRsdv6p9D3VQ3KdK";

  final _csLiveness = CsLiveness(
    clientId: clientId,
    clientSecret: clientSecret,
  );
  LivenessStore() : super(LivenessInitialState());

  Future<void> start() async {
    try {
      final result = await _csLiveness.start();
      value = LivenessSuccessState(result);
    } catch (e) {
      value = LivenessErrorState(e.toString());
    }
  }
}
