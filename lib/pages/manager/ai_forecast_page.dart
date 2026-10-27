import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class AiForecastPage extends StatelessWidget {
  const AiForecastPage({super.key});

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

          // Top Model Architecture Comparison Cards
          _buildArchitectureOverview(),
          const SizedBox(height: 24),

          // Main Forecast Chart & Input Variables Row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 850) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: _buildForecastChartCard()),
                    const SizedBox(width: 20),
                    Expanded(flex: 4, child: _buildPredictionInputsCard()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildForecastChartCard(),
                    const SizedBox(height: 20),
                    _buildPredictionInputsCard(),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),

          // Decision Flow Deep Dive
          _buildDecisionFlow(),
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
              color: const Color(0xFF2563EB).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('🤖', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Prediction & Forecasting Intelligence',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Two-tier ML pipeline integrating external environmental factors, customer traffic patterns, and real-time shelf velocity.',
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

  Widget _buildArchitectureOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildModelCard(
            title: 'Model 1 — Foot Traffic Prediction',
            algorithm: 'Time-Series Regression & Weather Embedding',
            inputs: 'Weather 🌦️ + Time 🕐 + Day 📅 + Payday 💰 + Historical 📊',
            output: 'Predicted Hourly Customer Foot Traffic (%)',
            badgeColor: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildModelCard(
            title: 'Model 2 — Dynamic Discount Optimization',
            algorithm: 'Probabilistic Sell-Through & Loss Minimization',
            inputs: 'Expiry Time ⏰ + Stock 📦 + Velocity ⚡ + Traffic Forecast 👥',
            output: 'Optimal Discount % (10% to 50% Flash Sale)',
            badgeColor: const Color(0xFF9333EA),
          ),
        ),
      ],
    );
  }

  Widget _buildModelCard({
    required String title,
    required String algorithm,
    required String inputs,
    required String output,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('ACTIVE ML', style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(algorithm, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), fontWeight: FontWeight.w500)),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          Text('INPUTS', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8))),
          Text(inputs, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF1E293B))),
          const SizedBox(height: 8),
          Text('OUTPUT', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8))),
          Text(output, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: badgeColor)),
        ],
      ),
    );
  }

  Widget _buildForecastChartCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '📈 AI FOOT TRAFFIC FORECAST (HOURLY)',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              Row(
                children: [
                  _buildLegendCircle(const Color(0xFF2563EB), 'AI Forecast'),
                  const SizedBox(width: 12),
                  _buildLegendCircle(const Color(0xFF16A34A), 'Actual Traffic'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => Text('${value.toInt()}%', style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const hours = ['12:00', '14:00', '16:00', '18:00', '20:00', '22:00'];
                        if (value >= 0 && value < hours.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(hours[value.toInt()], style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  // AI Forecast (Full curve across the day)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 45),
                      FlSpot(1, 68),
                      FlSpot(2, 82),
                      FlSpot(3, 54), // Drop at 18:00 due to rain
                      FlSpot(4, 38),
                      FlSpot(5, 22),
                    ],
                    isCurved: true,
                    color: const Color(0xFF2563EB),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                    ),
                  ),
                  // Actual Recorded Traffic (Up to 16:00)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 42),
                      FlSpot(1, 71),
                      FlSpot(2, 80),
                    ],
                    isCurved: true,
                    color: const Color(0xFF16A34A),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCircle(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildPredictionInputsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔮 PREDICTION INPUT METRICS',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 16),
          _buildInputRow('🌦️ Weather Condition', 'Heavy Rain (-35% traffic)'),
          _buildInputRow('🕐 Target Window', '18:00 - 20:00 (Dinner)'),
          _buildInputRow('💰 Payday Effect', '+12% Purchasing Power'),
          _buildInputRow('📅 Day of Week', 'Sunday (High Retail)'),
          _buildInputRow('📊 Historical Pattern', 'High Peak Baseline'),
          const Divider(height: 24, color: Color(0xFFE2E8F0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PREDICTED TRAFFIC', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                  Text('54%', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('CONFIDENCE SCORE', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                  Text('87%', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF16A34A))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
          Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _buildDecisionFlow() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 Why is this crucial for Judges & Retailers?',
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          Text(
            'Instead of arbitrary discounts, FreshFlow connects real-world environmental triggers (heavy rain dropping traffic) with shelf shelf-life. This ensures discounts are launched just in time to convert inventory into recovered revenue before spoilage occurs.',
            style: GoogleFonts.inter(fontSize: 13, height: 1.5, color: const Color(0xFF475569)),
          ),
        ],
      ),
    );
  }
}
