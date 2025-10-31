import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../domain/models/robot_data_point.dart';
import 'dart:math' as math;

class CustomLineChart extends StatefulWidget {
  final List<RobotDataPoint> data;

  const CustomLineChart({super.key, required this.data});

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  int? _hoveredIndex;
  Offset? _tapPosition;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            _handleTap(details.localPosition, constraints.maxWidth, constraints.maxHeight);
          },
          onTapUp: (_) {
            setState(() {
              _hoveredIndex = null;
              _tapPosition = null;
            });
          },
          child: MouseRegion(
            onHover: (event) {
              _handleHover(event.localPosition, constraints.maxWidth, constraints.maxHeight);
            },
            onExit: (_) {
              setState(() {
                _hoveredIndex = null;
                _tapPosition = null;
              });
            },
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _LineChartPainter(widget.data, _hoveredIndex),
                ),
                if (_hoveredIndex != null && _tapPosition != null)
                  _buildTooltip(constraints.maxWidth, constraints.maxHeight),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleTap(Offset position, double width, double height) {
    final index = _findNearestPoint(position, width, height);
    setState(() {
      _hoveredIndex = index;
      _tapPosition = position;
    });
  }

  void _handleHover(Offset position, double width, double height) {
    final index = _findNearestPoint(position, width, height);
    if (index != _hoveredIndex) {
      setState(() {
        _hoveredIndex = index;
        _tapPosition = position;
      });
    }
  }

  int? _findNearestPoint(Offset position, double width, double height) {
    const paddingLeft = 60.0;
    const paddingRight = 20.0;
    const paddingTop = 40.0;
    const paddingBottom = 60.0;

    final chartWidth = width - paddingLeft - paddingRight;
    final chartHeight = height - paddingTop - paddingBottom;

    final sortedData = List<RobotDataPoint>.from(widget.data)
      ..sort((a, b) => a.date.compareTo(b.date));

    if (sortedData.isEmpty) return null;

    final maxHours = sortedData.map((e) => e.hoursActive).reduce(math.max);
    final minHours = sortedData.map((e) => e.hoursActive).reduce(math.min);
    final yRange = maxHours - minHours;
    final yMax = maxHours + (yRange * 0.2);

    int? nearestIndex;
    double minDistance = double.infinity;

    for (int i = 0; i < sortedData.length; i++) {
      final x = paddingLeft + (chartWidth * i / (sortedData.length - 1));
      final normalizedValue = sortedData[i].hoursActive / yMax;
      final y = paddingTop + chartHeight - (chartHeight * normalizedValue);

      final distance = math.sqrt(
        math.pow(position.dx - x, 2) + math.pow(position.dy - y, 2),
      );

      if (distance < 20 && distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    return nearestIndex;
  }

  Widget _buildTooltip(double width, double height) {
    if (_hoveredIndex == null) return const SizedBox.shrink();

    final sortedData = List<RobotDataPoint>.from(widget.data)
      ..sort((a, b) => a.date.compareTo(b.date));

    final point = sortedData[_hoveredIndex!];
    final dateFormat = intl.DateFormat('MMM dd, yyyy');

    return Positioned(
      left: _tapPosition!.dx + 10,
      top: _tapPosition!.dy - 60,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dateFormat.format(point.date),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hours: ${point.hoursActive.toStringAsFixed(1)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
            Text(
              'Minutes: ${point.minutesActive}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<RobotDataPoint> data;
  final int? hoveredIndex;
  final double paddingLeft = 60;
  final double paddingRight = 20;
  final double paddingTop = 40;
  final double paddingBottom = 60;

  _LineChartPainter(this.data, this.hoveredIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final sortedData = List<RobotDataPoint>.from(data)
      ..sort((a, b) => a.date.compareTo(b.date));

    final maxHours = sortedData.map((e) => e.hoursActive).reduce(math.max);
    final minHours = sortedData.map((e) => e.hoursActive).reduce(math.min);
    final yRange = maxHours - minHours;
    final yMax = maxHours + (yRange * 0.2);

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;

    _drawGrid(canvas, size, chartWidth, chartHeight, yMax);
    _drawAxes(canvas, size, chartWidth, chartHeight);
    _drawYAxisLabels(canvas, size, chartHeight, yMax);
    _drawXAxisLabels(canvas, size, chartWidth, sortedData);
    _drawGradientFill(canvas, size, chartWidth, chartHeight, sortedData, yMax);
    _drawLine(canvas, size, chartWidth, chartHeight, sortedData, yMax);
    _drawDataPoints(canvas, size, chartWidth, chartHeight, sortedData, yMax);
  }

  void _drawGrid(
    Canvas canvas,
    Size size,
    double chartWidth,
    double chartHeight,
    double yMax,
  ) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      final y = paddingTop + (chartHeight * i / 5);
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(paddingLeft + chartWidth, y),
        paint,
      );
    }
  }

  void _drawAxes(
    Canvas canvas,
    Size size,
    double chartWidth,
    double chartHeight,
  ) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(paddingLeft, paddingTop),
      Offset(paddingLeft, paddingTop + chartHeight),
      paint,
    );

    canvas.drawLine(
      Offset(paddingLeft, paddingTop + chartHeight),
      Offset(paddingLeft + chartWidth, paddingTop + chartHeight),
      paint,
    );
  }

  void _drawYAxisLabels(
    Canvas canvas,
    Size size,
    double chartHeight,
    double yMax,
  ) {
    final textStyle = const TextStyle(color: Colors.black, fontSize: 12);

    for (int i = 0; i <= 5; i++) {
      final value = yMax * (5 - i) / 5;
      final y = paddingTop + (chartHeight * i / 5);

      final textSpan = TextSpan(
        text: value.toStringAsFixed(1),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          paddingLeft - textPainter.width - 10,
          y - textPainter.height / 2,
        ),
      );
    }

    final labelSpan = TextSpan(
      text: 'Hours',
      style: textStyle.copyWith(fontWeight: FontWeight.bold),
    );
    final labelPainter = TextPainter(
      text: labelSpan,
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();

    canvas.save();
    canvas.translate(15, size.height / 2 + labelPainter.width / 2);
    canvas.rotate(-math.pi / 2);
    labelPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  void _drawXAxisLabels(
    Canvas canvas,
    Size size,
    double chartWidth,
    List<RobotDataPoint> sortedData,
  ) {
    final textStyle = const TextStyle(color: Colors.black, fontSize: 12);
    final dateFormat = intl.DateFormat('MM/dd');

    // Calculate label width and determine skip interval
    const double estimatedLabelWidth = 50.0; // Estimated width for rotated labels
    final double availableWidth = chartWidth / sortedData.length;

    // Calculate how many labels we can show without overlap
    int skipInterval = 1;
    if (availableWidth < estimatedLabelWidth) {
      skipInterval = (estimatedLabelWidth / availableWidth).ceil();
    }

    // Always show first and last labels, and skip intermediate ones if needed
    for (int i = 0; i < sortedData.length; i++) {
      // Show label if it's the first, last, or falls on the skip interval
      final bool shouldShowLabel = i == 0 ||
                                   i == sortedData.length - 1 ||
                                   i % skipInterval == 0;

      if (!shouldShowLabel) continue;

      final x = paddingLeft + (chartWidth * i / (sortedData.length - 1));
      final dateText = dateFormat.format(sortedData[i].date);

      final textSpan = TextSpan(text: dateText, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(
        x,
        paddingTop + size.height - paddingTop - paddingBottom + 10,
      );
      canvas.rotate(-math.pi / 6);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, 0));
      canvas.restore();
    }
  }

  void _drawGradientFill(
    Canvas canvas,
    Size size,
    double chartWidth,
    double chartHeight,
    List<RobotDataPoint> sortedData,
    double yMax,
  ) {
    final path = Path();
    final baseY = paddingTop + chartHeight;

    path.moveTo(paddingLeft, baseY);

    for (int i = 0; i < sortedData.length; i++) {
      final x = paddingLeft + (chartWidth * i / (sortedData.length - 1));
      final normalizedValue = sortedData[i].hoursActive / yMax;
      final y = paddingTop + chartHeight - (chartHeight * normalizedValue);
      path.lineTo(x, y);
    }

    path.lineTo(paddingLeft + chartWidth, baseY);
    path.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.blue.withOpacity(0.5), Colors.blue.withOpacity(0.1)],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(paddingLeft, paddingTop, chartWidth, chartHeight),
      );

    canvas.drawPath(path, paint);
  }

  void _drawLine(
    Canvas canvas,
    Size size,
    double chartWidth,
    double chartHeight,
    List<RobotDataPoint> sortedData,
    double yMax,
  ) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    for (int i = 0; i < sortedData.length; i++) {
      final x = paddingLeft + (chartWidth * i / (sortedData.length - 1));
      final normalizedValue = sortedData[i].hoursActive / yMax;
      final y = paddingTop + chartHeight - (chartHeight * normalizedValue);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawDataPoints(
    Canvas canvas,
    Size size,
    double chartWidth,
    double chartHeight,
    List<RobotDataPoint> sortedData,
    double yMax,
  ) {
    for (int i = 0; i < sortedData.length; i++) {
      final x = paddingLeft + (chartWidth * i / (sortedData.length - 1));
      final normalizedValue = sortedData[i].hoursActive / yMax;
      final y = paddingTop + chartHeight - (chartHeight * normalizedValue);

      final isHovered = i == hoveredIndex;

      // Draw outer circle (white background)
      final outerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(x, y),
        isHovered ? 8 : 6,
        outerPaint,
      );

      // Draw inner circle (blue fill)
      final innerPaint = Paint()
        ..color = isHovered ? Colors.blueAccent : Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(x, y),
        isHovered ? 6 : 4,
        innerPaint,
      );

      // Draw highlight ring for hovered point
      if (isHovered) {
        final highlightPaint = Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawCircle(Offset(x, y), 10, highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
