import 'package:flutter/material.dart';

/// A lightweight press scale effect for tappable UI.
class BouncyTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final HitTestBehavior behavior;

  const BouncyTap({
    super.key,
    required this.child,
    required this.onTap,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<BouncyTap> createState() => _BouncyTapState();
}

class _BouncyTapState extends State<BouncyTap> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed != pressed) setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final scaledChild = AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOutCubic,
      child: widget.child,
    );
    if (widget.onTap == null) {
      return Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: scaledChild,
      );
    }
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: scaledChild,
    );
  }
}
