import 'package:flutter/material.dart';

/// Widget qui suggère de tourner l'appareil pour une meilleure expérience
class RotationSuggestion extends StatefulWidget {
  final bool shouldShow;
  final VoidCallback? onDismiss;

  const RotationSuggestion({
    super.key,
    required this.shouldShow,
    this.onDismiss,
  });

  @override
  State<RotationSuggestion> createState() => _RotationSuggestionState();
}

class _RotationSuggestionState extends State<RotationSuggestion>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void didUpdateWidget(RotationSuggestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.shouldShow && !_isVisible) {
      _showSuggestion();
    } else if (!widget.shouldShow && _isVisible) {
      _hideSuggestion();
    }
  }

  void _showSuggestion() {
    _isVisible = true;
    _animationController.forward();
    
    // Auto-hide après 4 secondes
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _isVisible) {
        _hideSuggestion();
      }
    });
  }

  void _hideSuggestion() {
    _isVisible = false;
    _animationController.reverse().then((_) {
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.shouldShow) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.screen_rotation,
                    color: Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Flexible(
                    child: Text(
                      "Tournez votre appareil pour une meilleure expérience",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _hideSuggestion,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
