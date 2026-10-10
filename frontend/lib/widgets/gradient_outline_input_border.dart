import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'package:strath_clean/theme/app_colors.dart';

/// An outline input border that strokes its outline with a [Gradient]
/// instead of a solid colour. Use it for `enabledBorder` / `focusedBorder`.
class GradientOutlineInputBorder extends OutlineInputBorder {
  const GradientOutlineInputBorder({
    required this.gradient,
    this.width = 1.5,
    super.borderRadius = cornerRadius,
  }) : super(borderSide: const BorderSide(width: 0));

  final Gradient gradient;
  final double width;

  @override
  GradientOutlineInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
  }) {
    return GradientOutlineInputBorder(
      gradient: gradient,
      width: borderSide?.width ?? width,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  // Smoothly animate between two gradient borders (e.g. unfocused -> focused).
  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientOutlineInputBorder) {
      return GradientOutlineInputBorder(
        gradient: Gradient.lerp(a.gradient, gradient, t)!,
        width: lerpDouble(a.width, width, t)!,
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    if (a != null) return t < 0.5 ? a : this;
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientOutlineInputBorder) {
      return GradientOutlineInputBorder(
        gradient: Gradient.lerp(gradient, b.gradient, t)!,
        width: lerpDouble(width, b.width, t)!,
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    if (b != null) return t < 0.5 ? this : b;
    return super.lerpTo(b, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final outline = borderRadius.toRRect(rect).deflate(width / 2);
    canvas.drawRRect(outline, paint);
  }

  @override
  bool operator ==(Object other) =>
      other is GradientOutlineInputBorder &&
      other.gradient == gradient &&
      other.width == width &&
      other.borderRadius == borderRadius;

  @override
  int get hashCode => Object.hash(gradient, width, borderRadius);
}