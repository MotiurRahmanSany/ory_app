import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';
part 'light_theme.dart';

@riverpod
ThemeData theme(Ref ref) {
  return _lightTheme;
}
