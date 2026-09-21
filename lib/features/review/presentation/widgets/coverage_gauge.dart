import 'dart:math';
import 'package:flutter/material.dart';

/// Widget vòng tròn tiến trình hiển thị tỷ lệ bao phủ Use Cases (Coverage)
class CoverageGauge extends StatefulWidget {
  final double coverageRatio; // 0.0 - 1.0
  final int coveredCount;
  final int totalCount;

  const CoverageGauge({
    super.key,
    required this.coverageRatio,
    required this.coveredCount,
    required this.totalCount,
  });

  @override
  State<CoverageGauge> createState() => _CoverageGaugeState();
}

class _CoverageGaugeState extends State<CoverageGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.coverageRatio.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(CoverageGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coverageRatio != widget.coverageRatio) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.coverageRatio.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getCoverageColor(double ratio) {
    if (widget.totalCount == 0) return Colors.blueGrey;
    if (ratio >= 0.8) return const Color(0xFF22C55E); // Green
    if (ratio >= 0.5) return const Color(0xFFEAB308); // Yellow/Amber
    return const Color(0xFFEF4444); // Red
  }

  String _getCoverageLabel(double ratio) {
    if (widget.totalCount == 0) return 'Chưa trích xuất được Use Case từ SRS';
    if (ratio >= 0.8) return 'Độ bao phủ cao';
    if (ratio >= 0.5) return 'Bao phủ trung bình';
    return 'Cần bổ sung test case';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCoverageColor(widget.coverageRatio);
    final label = _getCoverageLabel(widget.coverageRatio);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final percent = (_animation.value * 100).toStringAsFixed(1);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 170,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(170, 170),
                    painter: _GaugePainter(
                      progress: _animation.value,
                      color: color,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.totalCount == 0)
                        Text(
                          'N/A',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              percent,
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            Text(
                              '%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 2),
                      Text(
                        'COVERAGE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.totalCount == 0
                  ? 'Không tìm thấy đề mục Use Case'
                  : '${widget.coveredCount} / ${widget.totalCount} Use Cases',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;

  _GaugePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 14.0;
    const startAngle = 0.75 * pi; // 135 degrees
    const sweepTotal = 1.5 * pi; // 270 degrees total sweep

    // Background track arc
    final trackPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      trackPaint,
    );

    // Active progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepTotal * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
