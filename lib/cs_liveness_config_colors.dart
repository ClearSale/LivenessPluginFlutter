import 'package:cs_liveness_flutter/cs_liveness_flutter.dart';
import 'package:flutter/material.dart';

class CsLivenessConfigColors {
  final Color? primary;
  final Color? secondary;
  final Color? title;
  final Color? paragraph;

  CsLivenessConfigColors({this.primary, this.secondary, this.title, this.paragraph});

  Map<String, dynamic> toJson() => {
      'primary': primary != null ? "#${primary?.value.toRadixString(16)}" : null,
      'secondary': secondary != null ? "#${secondary?.value.toRadixString(16)}" : null,
      'title': title != null ? "#${title?.value.toRadixString(16)}" : null,
      'paragraph': paragraph != null ? "#${primary?.value.toRadixString(16)}" : null
     };
}