import 'dart:convert';

import 'package:cs_liveness_flutter/cs_liveness_config_colors.dart';

class CsLivenessConfig {
  final bool vocalGuidance;
  final CsLivenessConfigColors? colors;

  const CsLivenessConfig({this.vocalGuidance = false, this.colors});

  Map<String, dynamic> toJson() => {
       'vocalGuidance': vocalGuidance,
       'colors': colors?.toJson(),
     };
}