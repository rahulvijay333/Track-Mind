import 'package:flutter/material.dart';

const space5 = SizedBox(height: 5);
const space10 = SizedBox(height: 10);
const space15 = SizedBox(height: 15);
const space20 = SizedBox(height: 20);

// Colors - Uber Style
const kBackgroundColor = Color(0xFF000000); // Pure Black
const kCardColor = Color(0xFF121212);       // Eerie Black / Deep Grey
const kAccentColor = Color(0xFF38BDF8);
const kSecondaryAccent = Color(0xFF818CF8);
const kImportantColor = Color(0xFFFB7185);
const kTextColor = Color(0xFFFFFFFF);       // High Contrast White
const kTextMutedColor = Color(0xFF94A3B8);

// Gradients
const kPrimaryGradient = LinearGradient(
  colors: [kAccentColor, kSecondaryAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Glassmorphism effect
final kGlassDecoration = BoxDecoration(
  color: Colors.white.withValues(alpha: 0.05),
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);

// TextStyles - Using System default fonts for Uber minimalist look
const TextStyle kTitleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kTextColor,
);

const TextStyle kBodyStyle = TextStyle(
  fontSize: 16,
  color: kTextColor,
);

const TextStyle kMutedStyle = TextStyle(
  fontSize: 14,
  color: kTextMutedColor,
);