import 'package:flutter/material.dart';

class VibeItem {
  final String title;
  final String emoji;
  final Color backgroundColor;
  final String description;
  final List<String> places;

  const VibeItem({
    required this.title,
    required this.emoji,
    required this.backgroundColor,
    required this.description,
    required this.places,
  });
}
