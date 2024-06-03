import 'package:flutter/services.dart';

String _padRadix(int value) => value.toRadixString(16).padLeft(2, '0');

String _colorToHex(
  Color color, {
  bool includeHashSign = false,
  bool enableAlpha = true,
  bool toUpperCase = true,
}) {
  final String hex = (includeHashSign ? '#' : '') +
      (enableAlpha ? _padRadix(color.alpha) : '') +
      _padRadix(color.red) +
      _padRadix(color.green) +
      _padRadix(color.blue);
  return toUpperCase ? hex.toUpperCase() : hex;
}

extension ColorExtension on Color {
  String toHexString(
          {bool includeHashSign = false,
          bool enableAlpha = true,
          bool toUpperCase = true}) =>
      _colorToHex(this,
          includeHashSign: includeHashSign, enableAlpha: enableAlpha, toUpperCase: toUpperCase);
}
