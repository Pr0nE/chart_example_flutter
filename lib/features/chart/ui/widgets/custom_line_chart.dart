// ignore_for_file: deprecated_member_use

import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';
import 'package:chart_example_flutter/features/chart/domain/models/chart_point.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
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
  double _zoomLevel = 1.0;
  final ScrollController _scrollController = ScrollController();

  List<ChartPoint> _cachedChartPoints = [];
  double? _cachedWidth;
  double? _cachedHeight;

  static const double _minZoom = 1.0;
  static const double _maxZoom = 5.0;
  static const double _zoomStep = 0.5;

  @override
  void didUpdateWidget(CustomLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _cachedChartPoints = [];
      _cachedWidth = null;
      _cachedHeight = null;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<ChartPoint> _getChartPoints(double width, double height) {
    if (_cachedWidth != width ||
        _cachedHeight != height ||
        _cachedChartPoints.isEmpty) {
      _cachedWidth = width;
      _cachedHeight = height;
      _cachedChartPoints = _calculateChartPoints(width, height);
    }
    return _cachedChartPoints;
  }

  void _zoomIn() {
    setState(() {
      if (_zoomLevel < _maxZoom) {
        _zoomLevel = math.min(_zoomLevel + _zoomStep, _maxZoom);
      }
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoomLevel > _minZoom) {
        _zoomLevel = math.max(_zoomLevel - _zoomStep, _minZoom);
      }
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = _minZoom;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  bool get _isZoomed => _zoomLevel > _minZoom;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartHeight = constraints.maxHeight;
        final chartWidth = constraints.maxWidth * _zoomLevel;

        return Stack(
          children: [
            _isZoomed
                ? Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    thickness: 12,
                    radius: const Radius.circular(6),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        width: chartWidth,
                        height: chartHeight,
                        child: _buildChartContent(chartWidth, chartHeight),
                      ),
                    ),
                  )
                : _buildChartContent(chartWidth, chartHeight),
            _buildZoomControls(),
          ],
        );
      },
    );
  }

  Widget _buildChartContent(double width, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: _isZoomed
          ? (details) {
              if (_scrollController.hasClients) {
                final newOffset = _scrollController.offset - details.delta.dx;
                _scrollController.jumpTo(
                  newOffset.clamp(
                    0.0,
                    _scrollController.position.maxScrollExtent,
                  ),
                );
              }
            }
          : null,
      onTapDown: (details) {
        _handleTap(details.localPosition, width, height);
      },
      onTapUp: (_) {
        setState(() {
          _hoveredIndex = null;
          _tapPosition = null;
        });
      },
      child: MouseRegion(
        onHover: (event) {
          _handleHover(event.localPosition, width, height);
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
              size: Size(width, height),
              painter: _LineChartPainter(
                widget.data,
                _hoveredIndex,
                _getChartPoints(width, height),
              ),
            ),
            if (_hoveredIndex != null && _tapPosition != null)
              _buildTooltip(width, height),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 16,
      top: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _zoomLevel < _maxZoom ? _zoomIn : null,
              tooltip: 'Zoom In',
              iconSize: 20,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
            Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${(_zoomLevel * 100).toInt()}%',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _zoomLevel > _minZoom ? _zoomOut : null,
              tooltip: 'Zoom Out',
              iconSize: 20,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
            if (_isZoomed)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetZoom,
                tooltip: 'Reset Zoom',
                iconSize: 20,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
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

  List<ChartPoint> _calculateChartPoints(double width, double height) {
    const paddingLeft = 60.0;
    const paddingRight = 20.0;
    const paddingTop = 40.0;
    const paddingBottom = 60.0;

    final chartWidth = width - paddingLeft - paddingRight;
    final chartHeight = height - paddingTop - paddingBottom;

    final sortedData = List<RobotDataPoint>.from(widget.data)
      ..sort((a, b) => a.date.compareTo(b.date));

    if (sortedData.isEmpty) return [];

    final maxHours = sortedData.map((e) => e.hoursActive).reduce(math.max);
    final minHours = sortedData.map((e) => e.hoursActive).reduce(math.min);
    final yRange = maxHours - minHours;
    final yMax = maxHours + (yRange * 0.2);

    return List.generate(sortedData.length, (i) {
      final x = paddingLeft + (chartWidth * i / (sortedData.length - 1));
      final normalizedValue = sortedData[i].hoursActive / yMax;
      final y = paddingTop + chartHeight - (chartHeight * normalizedValue);
      return ChartPoint(index: i, x: x, y: y, data: sortedData[i]);
    });
  }

  int? _findNearestPoint(Offset position, double width, double height) {
    final chartPoints = _getChartPoints(width, height);

    int? nearestIndex;
    double minDistance = double.infinity;

    for (final point in chartPoints) {
      final distance = math.sqrt(
        math.pow(position.dx - point.x, 2) + math.pow(position.dy - point.y, 2),
      );

      if (distance < 20 && distance < minDistance) {
        minDistance = distance;
        nearestIndex = point.index;
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

    const double tooltipWidth = 150.0;

    final bool wouldOverflowRight = _tapPosition!.dx + tooltipWidth > width;

    final double leftPosition = wouldOverflowRight
        ? _tapPosition!.dx - tooltipWidth
        : _tapPosition!.dx;

    return Positioned(
      left: leftPosition,
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
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            Text(
              'Minutes: ${point.minutesActive}',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
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
  final List<ChartPoint> chartPoints;
  final double paddingLeft = 60;
  final double paddingRight = 20;
  final double paddingTop = 40;
  final double paddingBottom = 60;

  _LineChartPainter(this.data, this.hoveredIndex, this.chartPoints);

  @override
  void paint(Canvas canvas, Size size) {
    if (chartPoints.isEmpty) return;

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
    _drawGradientFill(canvas, size, chartWidth, chartHeight);
    _drawLine(canvas, size, chartWidth, chartHeight);
    _drawDataPoints(canvas, size, chartWidth, chartHeight);
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
    const double estimatedLabelWidth =
        50.0; // Estimated width for rotated labels
    final double availableWidth = chartWidth / sortedData.length;

    // Calculate how many labels we can show without overlap
    int skipInterval = 1;
    if (availableWidth < estimatedLabelWidth) {
      skipInterval = (estimatedLabelWidth / availableWidth).ceil();
    }

    // Always show first and last labels, and skip intermediate ones if needed
    for (int i = 0; i < sortedData.length; i++) {
      // Show label if it's the first, last, or falls on the skip interval
      final bool shouldShowLabel =
          i == 0 || i == sortedData.length - 1 || i % skipInterval == 0;

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
  ) {
    if (chartPoints.isEmpty) return;

    final path = Path();
    final baseY = paddingTop + chartHeight;

    path.moveTo(paddingLeft, baseY);

    for (final point in chartPoints) {
      path.lineTo(point.x, point.y);
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
  ) {
    if (chartPoints.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    for (int i = 0; i < chartPoints.length; i++) {
      if (i == 0) {
        path.moveTo(chartPoints[i].x, chartPoints[i].y);
      } else {
        path.lineTo(chartPoints[i].x, chartPoints[i].y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawDataPoints(
    Canvas canvas,
    Size size,
    double chartWidth,
    double chartHeight,
  ) {
    for (final point in chartPoints) {
      final isHovered = point.index == hoveredIndex;

      // Draw outer circle (white background)
      final outerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(point.x, point.y),
        isHovered ? 8 : 6,
        outerPaint,
      );

      // Draw inner circle (blue fill)
      final innerPaint = Paint()
        ..color = isHovered ? Colors.blueAccent : Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(point.x, point.y),
        isHovered ? 6 : 4,
        innerPaint,
      );

      // Draw highlight ring for hovered point
      if (isHovered) {
        final highlightPaint = Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawCircle(Offset(point.x, point.y), 10, highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
