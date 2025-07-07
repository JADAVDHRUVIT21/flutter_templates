import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum TriangleAlignment { left, center, right }

class SkeletonLoader extends StatelessWidget {
  final int itemCount;
  final List<String> baseSequence;
  final double spacing;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final bool showAvatar;
  final bool showTriangle;
  final TriangleAlignment triangleAlignment;
  final bool isRow; // Added property to switch between Row and Column

  const SkeletonLoader({
    super.key,
    this.itemCount = 6,
    required this.baseSequence,
    this.spacing = 16,
    this.borderRadius = 12,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.showAvatar = true,
    this.showTriangle = true,
    this.triangleAlignment = TriangleAlignment.left,
    this.isRow = false,
  });

  double _parseSize({
    required String value,
    required double max,
    required double fallback,
  }) {
    if (value.endsWith('%')) {
      final percentage = double.tryParse(value.replaceAll('%', '')) ?? 0;
      return max * (percentage / 100);
    } else {
      return double.tryParse(value) ?? fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final sequence = baseSequence.expand((item) => [item, 'gap height:$spacing']).toList();
    if (sequence.isNotEmpty) sequence.removeLast();

    return Column(
      children: List.generate(itemCount, (index) {
        final children = <Widget>[];

        for (int i = 0; i < sequence.length; i++) {
          final item = sequence[i];

          if (item.startsWith('gap')) {
            final heightMatch = RegExp(r'height:\s*([0-9.]+%?)').firstMatch(item);
            final gapValue = double.tryParse(heightMatch?.group(1) ?? '0') ?? spacing;

            children.add(isRow ? SizedBox(width: gapValue) : SizedBox(height: gapValue));
            continue;
          }

          final type = item.split(' ').first;

          final widthMatch = RegExp(r'width:\s*([0-9.]+%?)').firstMatch(item);
          final heightMatch = RegExp(r'height:\s*([0-9.]+%?)').firstMatch(item);

          final widthStr = widthMatch?.group(1) ?? '100';
          final heightStr = heightMatch?.group(1) ?? '12';

          final double width = _parseSize(value: widthStr, max: screenWidth, fallback: 100);
          final double height = _parseSize(value: heightStr, max: 200, fallback: 12);

          Widget widget;

          switch (type) {
            case 'avatar':
              if (!showAvatar) continue;
              final size = width < height ? width : height;
              widget = Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              );
              break;

            case 'circle':
              final size = width < height ? width : height;
              widget = Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              );
              break;

            case 'title':
            case 'subtitle':
              widget = Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              );
              break;

            case 'triangle':
              if (!showTriangle) continue;
              widget = Align(
                alignment: triangleAlignment == TriangleAlignment.center
                    ? Alignment.center
                    : triangleAlignment == TriangleAlignment.right
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: CustomPaint(
                  size: Size(width, height),
                  painter: TrianglePainter(color: Colors.white),
                ),
              );
              break;

            default:
              continue;
          }

          children.add(widget);
        }

        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: isRow
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        );
      }),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
