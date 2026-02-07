import 'package:flutter/material.dart';

class KeyButton extends StatelessWidget {
  final String label;
  final int flex;
  final VoidCallback onTap;
  final Color? color;

  const KeyButton({
    super.key,
    required this.label,
    this.flex = 2,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          color: color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            hoverColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.white10,
                  width: 1,
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
