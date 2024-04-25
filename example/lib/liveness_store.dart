// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cs_liveness_flutter/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/liveness_state.dart';

class LivenessStore extends ValueNotifier<LivenessState> {
  static const String clientId = "";
  static const String clientSecret = "";
  static const String identifierId = "";
  static const String cpf = "";
  static CsLivenessConfigColors colors = CsLivenessConfigColors(primary: Color(0xffaabbFF), secondary: Color(0xffffff00));
  static CsLivenessConfig config = CsLivenessConfig(vocalGuidance: true, colors: colors);

  final _csLiveness = CsLiveness(
    clientId: clientId,
    clientSecret: clientSecret,
    identifierId: identifierId,
    cpf: cpf,
    config: config
  );
  LivenessStore() : super(LivenessInitialState());

  Future<void> start() async {
    value = LivenessLoadingState(true);
    try {
      final result = await _csLiveness.start();
      value = LivenessSuccessState(result);
    } on CSLivenessCancelByUserException catch (e) {
      value = LivenessErrorState("Usuário cancelou a ação.");
    } catch (e) {
      value = LivenessErrorState(e.toString());
    }
  }

  void clean() {
    value = LivenessInitialState();
  }
}
