
import 'package:cs_liveness_flutter/cs_liveness_result.dart';

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
