import 'package:flutter/material.dart';

class MouseWidget extends StatelessWidget {
  final Function(String) onButtonTap;
  final bool Function(String) isBound;

  const MouseWidget({
    super.key,
    required this.onButtonTap,
    required this.isBound,
  });

  @override
  Widget build(BuildContext context) {
    // Dimensions
    const double containerWidth = 240;
    const double containerHeight = 320;
    const double bodyWidth = 200;
    const double bodyHeight = 260;
    
    return Container(
      width: containerWidth,
      height: containerHeight,
      padding: const EdgeInsets.all(5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Body
          Positioned(
            top: 20,
            child: Container(
              width: bodyWidth,
              height: bodyHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(60),
                  bottom: Radius.circular(50),
                ),
                border: Border.all(color: Colors.white10, width: 1),
              ),
            ),
          ),

          // LMB
          Positioned(
            top: 20,
            left: 20,
            child: _MouseButton(
              label: 'LMB',
              rustKey: 'mouse0',
              width: 55,
              height: 90,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              onTap: onButtonTap,
              isBound: isBound,
            ),
          ),

          // RMB
          Positioned(
            top: 20,
            right: 20,
            child: _MouseButton(
              label: 'RMB',
              rustKey: 'mouse1',
              width: 55,
              height: 90,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60),
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              onTap: onButtonTap,
              isBound: isBound,
            ),
          ),

          // MMB
          Positioned(
            top: 50,
            child: _SimpleButton(
              label: 'MMB',
              rustKey: 'mouse2',
              height: 70,
              onTap: onButtonTap,
              isBound: isBound,
            ),
          ),

          // Side Buttons
          Positioned(
            top: 130,
            left: 5,
            child: Column(
              children: [
                _MouseButton(
                  label: 'M4',
                  rustKey: 'mouse4',
                  width: 30,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  onTap: onButtonTap,
                  isBound: isBound,
                ),
                const SizedBox(height: 6),
                _MouseButton(
                  label: 'M3',
                  rustKey: 'mouse3',
                  width: 30,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  onTap: onButtonTap,
                  isBound: isBound,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MouseButton extends StatelessWidget {
  final String label;
  final String rustKey;
  final double width;
  final double height;
  final BoxDecoration decoration;
  final Function(String) onTap;
  final bool Function(String) isBound;

  const _MouseButton({
    required this.label,
    required this.rustKey,
    required this.width,
    required this.height,
    required this.decoration,
    required this.onTap,
    required this.isBound,
  });

  @override
  Widget build(BuildContext context) {
    final bool bound = isBound(rustKey);
    final Color baseColor = const Color(0xFF252525);
    final Color activeColor = Theme.of(context).primaryColor.withOpacity(0.4);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(rustKey),
        borderRadius: decoration.borderRadius as BorderRadius?,
        child: Ink(
          width: width,
          height: height,
          decoration: decoration.copyWith(
            color: bound ? activeColor : baseColor,
            border: Border.all(
              color: bound ? Theme.of(context).primaryColor : Colors.white12,
              width: bound ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: bound ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleButton extends StatelessWidget {
  final String label;
  final String rustKey;
  final double height;
  final Function(String) onTap;
  final bool Function(String) isBound;

  const _SimpleButton({
    required this.label,
    required this.rustKey,
    required this.height,
    required this.onTap,
    required this.isBound,
  });

  @override
  Widget build(BuildContext context) {
    final bool bound = isBound(rustKey);
    final Color activeColor = Theme.of(context).primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(rustKey),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 30,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bound ? activeColor.withOpacity(0.4) : const Color(0xFF333333),
            borderRadius: BorderRadius.circular(4),
            border: bound ? Border.all(color: activeColor) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: bound ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
