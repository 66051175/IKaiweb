import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/mock_data.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 20),

          // Core Impact Numbers
          _buildImpactMetricsRow(),
          const SizedBox(height: 24),

          // Before vs After & Monthly Recovery Charts
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 850) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildBeforeAfterWasteCard()),
                    const SizedBox(width: 20),
                    Expanded(child: _buildMonthlyRevenueCard()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildBeforeAfterWasteCard(),
                    const SizedBox(height: 20),
                    _buildMonthlyRevenueCard(),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),

          // Environmental & Financial ROI Card
          _buildRoiCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('📊', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business Impact & Sustainability Analytics',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantifiable ROI: Recovered revenue from expiring stock, food waste mass reduction, and stockout prevention.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildImpactCard(
            title: 'Food Saved Today',
            value: '${kpiData['foodSavedItems']} items',
            sub: '18.4 kg food saved',
            color: const Color(0xFF16A34A),
            icon: Icons.eco_outlined,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildImpactCard(
            title: 'Revenue Recovered',
            value: '฿12,450',
            sub: '+18% vs weekly avg',
            color: const Color(0xFF2563EB),
            icon: Icons.savings_outlined,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildImpactCard(
            title: 'Stockouts Prevented',
            value: '${kpiData['stockoutsPrevented']}',
            sub: 'Zero lost sales',
            color: const Color(0xFFF59E0B),
            icon: Icons.shield_outlined,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildImpactCard(
            title: 'CO₂ Reduced',
            value: '${kpiData['co2ReducedKg']} kg',
            sub: 'Carbon offset',
            color: const Color(0xFF9333EA),
            icon: Icons.cloud_done_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildImpactCard({
    required String title,
    required String value,
    required String sub,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          const SizedBox(height: 2),
          Text(sub, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildBeforeAfterWasteCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🗑️ DAILY FOOD WASTE COMPARISON',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 6),
          Text(
            'Before FreshFlow vs. After AI Dynamic Clearance',
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 24),

          // Before FreshFlow Bar
          Text('Before FreshFlow (Baseline)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                flex: 42,
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: const Text('42.0 kg / day', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const Expanded(flex: 0, child: SizedBox()),
            ],
          ),

          const SizedBox(height: 18),

          // After FreshFlow Bar
          Text('After FreshFlow AI (Today)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF16A34A))),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                flex: 18,
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: const Text('18.4 kg (-56%)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const Expanded(flex: 24, child: SizedBox()),
            ],
          ),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF86EFAC)),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_downward, color: Color(0xFF16A34A), size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '23.6 kg of fresh groceries prevented from landfill daily (56.2% reduction).',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF166534)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyRevenueCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '💰 RECOVERED REVENUE GROWTH',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              Text('Monthly (THB)', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 15000,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        return Text('฿${(value / 1000).toInt()}k', style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)));
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr'];
                        if (value >= 0 && value < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(months[value.toInt()], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeBarGroup(0, 8200),
                  _makeBarGroup(1, 9450),
                  _makeBarGroup(2, 11200),
                  _makeBarGroup(3, 12450, isHighlight: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, {bool isHighlight = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isHighlight ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _buildRoiCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('🎯', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FreshFlow ROI Pitch Summary',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '1 store saves an estimated ฿373,500 annually in avoided disposal losses, while uplifting store margins by 4.2% and achieving zero food waste compliance.',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFCBD5E1), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
