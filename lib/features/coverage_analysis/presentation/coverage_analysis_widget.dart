import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:insurance_flutter/core/constants/app_colors.dart';
import 'package:insurance_flutter/features/coverage_analysis/data/mock_coverage_data.dart';
import 'package:insurance_flutter/features/coverage_analysis/data/coverage_status_enum.dart';
import 'dart:math' as math;

class CoverageAnalysisWidget extends StatefulWidget {
  const CoverageAnalysisWidget({super.key});

  @override
  State<CoverageAnalysisWidget> createState() => _CoverageAnalysisWidgetState();
}

class _CoverageAnalysisWidgetState extends State<CoverageAnalysisWidget> with SingleTickerProviderStateMixin {
  AnimationController? _scoreController;
  Animation<double>? _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _scoreController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Get target percentage
    final current = mockCoverageData.currentCoverage;
    final target = mockCoverageData.targetCoverage;
    final rawPercentage = target > 0 ? current / target : 0.0;
    
    _scoreAnimation = Tween<double>(begin: 0.0, end: rawPercentage).animate(
      CurvedAnimation(parent: _scoreController!, curve: Curves.easeOutCubic),
    );

    if (mounted) {
       _scoreController!.reset();
       _scoreController!.forward();
    }
  }

  @override
  void dispose() {
    _scoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = mockCoverageData;
    // Determine Status color for Gauge (simplified logic or import enum)
    final status = CoverageStatus.fromValues(data.currentCoverage, data.targetCoverage);
    Color gaugeColor;
    if (status == CoverageStatus.underinsured) {
      gaugeColor = const Color(0xFFEF4444); // Red
    } else if (status == CoverageStatus.overinsured) {
      gaugeColor = const Color(0xFF0EA5E9); // Blue
    } else {
      gaugeColor = const Color(0xFF10B981); // Green
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status == CoverageStatus.underinsured ? const Color(0xFFFFEBEE) : 
                     status == CoverageStatus.overinsured ? const Color(0xFFE0F2FE) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: status == CoverageStatus.underinsured ? const Color(0xFFFFCDD2) :
                       status == CoverageStatus.overinsured ? const Color(0xFFB3E5FC) : const Color(0xFFC8E6C9)
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  status == CoverageStatus.underinsured ? Icons.warning_amber_rounded :
                  status == CoverageStatus.overinsured ? Icons.info_outline_rounded : Icons.check_circle_outline_rounded,
                  size: 16, 
                  color: gaugeColor
                ),
                const SizedBox(width: 6),
                Text(
                  data.status,
                  style: GoogleFonts.inter(
                    color: gaugeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // Content Row: Blocks + Gauge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // -- Compact Horizontal Blocks --
              Expanded(
                child: Row(
                  children: [
                    // Health Block
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                                  ),
                                  child: Icon(Icons.favorite_rounded, size: 14, color: Colors.blue.shade400),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Health',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF64748B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Target Section (Dominant)
                                Text(
                                  'Target Goal',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8), // Light slate
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatCurrency(data.healthTarget),
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF0F172A), // Dark slate
                                    fontSize: 22, // Bigger
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.blue.withOpacity(0.1),
                                ),
                                const SizedBox(height: 12),
                                
                                // Existing Section (Secondary)
                                Row(
                                  children: [
                                    Text(
                                      'Existing: ',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF64748B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      _formatCurrency(data.healthCurrent),
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF334155),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),

                    // Term Block
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.purple.withOpacity(0.1)),
                                  ),
                                  child: Icon(Icons.security_rounded, size: 14, color: Colors.purple.shade400),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Term',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF64748B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Target Section (Dominant)
                                Text(
                                  'Target Goal',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatCurrency(data.termTarget),
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF0F172A),
                                    fontSize: 22, // Bigger
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.purple.withOpacity(0.1),
                                ),
                                const SizedBox(height: 12),

                                // Existing Section (Secondary)
                                Row(
                                  children: [
                                    Text(
                                      'Existing: ',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF64748B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      _formatCurrency(data.termCurrent),
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF334155),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),
              
              // Animated Circular Gauge
              AnimatedBuilder(
                animation: _scoreAnimation!,
                builder: (context, child) {
                  return SizedBox(
                    height: 180,
                    width: 180,
                    child: CustomPaint(
                      painter: _GaugePainter(
                        percentage: _scoreAnimation!.value.clamp(0.0, 1.0),
                        needleColor: const Color(0xFF1E293B),
                        accentColor: gaugeColor,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child:  Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(_scoreAnimation!.value * 100).toInt()}%',
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                'Total Coverage',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ],
          ),


        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(1)} Cr';
    } else if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)} L';
    } else {
      return '₹${value.toStringAsFixed(0)}';
    }
  }
}

class _GaugePainter extends CustomPainter {
  final double percentage; // 0.0 to 1.0
  final Color needleColor;
  final Color accentColor;

  _GaugePainter({
    required this.percentage, 
    required this.needleColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = (size.width / 2) - 8; 

    // Geometry: 240 degree arc
    const double startAngle = 5 * math.pi / 6;
    const double sweepAngle = 4 * math.pi / 3;

    // 1. Draw Tick Marks
    final tickPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final int tickCount = 40;
    for (int i = 0; i <= tickCount; i++) {
      final tickPercent = i / tickCount;
      final tickAngle = startAngle + (tickPercent * sweepAngle);
      
      final outerOffset = Offset(
        center.dx + (radius + 4) * math.cos(tickAngle),
        center.dy + (radius + 4) * math.sin(tickAngle),
      );
      final innerOffset = Offset(
        center.dx + (radius - 2) * math.cos(tickAngle),
        center.dy + (radius - 2) * math.sin(tickAngle),
      );
      
      if (i % 10 == 0) {
        tickPaint.strokeWidth = 2;
        tickPaint.color = Colors.grey.withOpacity(0.5);
         final boldInnerOffset = Offset(
          center.dx + (radius - 5) * math.cos(tickAngle),
          center.dy + (radius - 5) * math.sin(tickAngle),
        );
        canvas.drawLine(boldInnerOffset, outerOffset, tickPaint);
      } else {
        tickPaint.strokeWidth = 1;
        tickPaint.color = Colors.grey.withOpacity(0.2);
        canvas.drawLine(innerOffset, outerOffset, tickPaint);
      }
    }

    // 2. Draw Color Track
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 2);
    canvas.translate(-center.dx, -center.dy);

    final rect = Rect.fromCircle(center: center, radius: radius - 8);
    final adjustedStart = startAngle - (math.pi / 2);
    
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: adjustedStart,
        endAngle: adjustedStart + sweepAngle,
        colors: const [
          Color(0xFFEF4444), // Red
          Color(0xFFF97316), // Orange
          Color(0xFFEAB308), // Yellow
          Color(0xFF10B981), // Green
        ],
        stops: const [0.0, 0.33, 0.66, 1.0], 
        tileMode: TileMode.clamp,
      ).createShader(rect);

    canvas.drawArc(rect, adjustedStart, sweepAngle, false, trackPaint);
    canvas.restore();

    // 3. Draw Needle
    final currentAngle = startAngle + (percentage * sweepAngle);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(currentAngle);

    final needlePath = Path();
    needlePath.moveTo(0, -3);         
    needlePath.lineTo(radius - 5 - 8, 0); 
    needlePath.lineTo(0, 3);          
    needlePath.lineTo(-8, 0);         
    needlePath.close();

    canvas.drawShadow(needlePath, Colors.black.withOpacity(0.4), 4, true);

    final needlePaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(needlePath, needlePaint);
    
    canvas.restore();

    // 4. Center Knob
    final knobPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 5, knobPaint);
    
    final knobInnerPaint = Paint()..color = accentColor;
    canvas.drawCircle(center, 2.5, knobInnerPaint);
    
    final knobBorderPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, 5, knobBorderPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || 
           oldDelegate.needleColor != needleColor ||
           oldDelegate.accentColor != accentColor;
  }
}
