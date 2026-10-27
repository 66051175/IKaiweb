import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_provider.dart';

class ManagerDashboard extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const ManagerDashboard({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16.0 : 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome & Store Status
              _buildGreetingBanner(context, isMobile),
              const SizedBox(height: 20),

              // KPI Metric Cards
              _buildKpiSection(context, isMobile),
              const SizedBox(height: 24),

              // Floorplan & Alerts Section
              if (isMobile) ...[
                _buildFloorplanCard(context),
                const SizedBox(height: 20),
                _buildAlertsCard(context),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildFloorplanCard(context)),
                    const SizedBox(width: 24),
                    Expanded(flex: 4, child: _buildAlertsCard(context)),
                  ],
                ),
              ],
              const SizedBox(height: 24),

              // Charts Row
              if (isMobile) ...[
                _buildSalesWasteChart(),
                const SizedBox(height: 20),
                _buildTrafficChart(),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildSalesWasteChart()),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTrafficChart()),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildGreetingBanner(BuildContext context, bool isMobile) {
    final user = context.watch<AppProvider>().currentUser;
    final userName = user?['name'] ?? 'Manager';
    final userBranch = user?['branch'] ?? 'Store #001 (Central Bangkok)';

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Good Afternoon, $userName 👋',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 18 : 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$userBranch · Today · Live AI Clearance Active',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 12 : 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(
                  'SYSTEM ONLINE',
                  style: GoogleFonts.inter(color: const Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiSection(BuildContext context, bool isMobile) {
    final provider = context.watch<AppProvider>();
    final summary = provider.backendDashboardSummary;
    final isLive = provider.isBackendOnline && summary != null;

    final kpiOpening = isLive ? '${summary['total_opening_units'] ?? 556} Units' : '18.4 kg';
    final kpiOpeningTitle = isLive ? 'Total Opening Stock' : 'Food Waste';
    final kpiOpeningSub = isLive ? 'STORE_01 (2026-10-12)' : '↓ 24% vs yesterday';

    final kpiNearExpiry = isLive ? '${summary['near_expiry_in_stock_count'] ?? 16} Items' : '7 Items';
    final kpiNearExpiryTitle = isLive ? 'Expiring (0-2 Days)' : 'Out of Stock';
    final kpiNearExpirySub = isLive ? '⚠️ Fast Clearance Needed' : '🔴 3 Critical';

    final kpiDiscounts = isLive ? '${summary['action_counts']?['DISCOUNT'] ?? 12} Markdowns' : '86 Items';
    final kpiDiscountsTitle = isLive ? 'AI Actions Proposed' : 'Discounted Sold';
    final kpiDiscountsSub = isLive ? '${summary['action_counts']?['RESTOCK'] ?? 5} Restock Alerts' : 'Clearance deals';

    final kpiDb = isLive ? 'FastAPI Online' : '฿12,450';
    final kpiDbTitle = isLive ? 'Database Status' : 'Saved Revenue';
    final kpiDbSub = isLive ? 'SQLite 128 Snapshots' : 'from expiring stock';

    if (isMobile) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
        children: [
          _KpiCard(
            title: kpiOpeningTitle,
            value: kpiOpening,
            change: isLive ? 0 : -24,
            sub: kpiOpeningSub,
            icon: Icons.inventory_2_outlined,
            iconBg: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF2563EB),
          ),
          _KpiCard(
            title: kpiDbTitle,
            value: kpiDb,
            change: isLive ? 100 : 18,
            sub: kpiDbSub,
            icon: Icons.cloud_done_outlined,
            iconBg: const Color(0xFFF0FDF4),
            iconColor: const Color(0xFF16A34A),
          ),
          _KpiCard(
            title: kpiNearExpiryTitle,
            value: kpiNearExpiry,
            change: isLive ? -16 : -5,
            sub: kpiNearExpirySub,
            icon: Icons.warning_amber_rounded,
            iconBg: const Color(0xFFFFFBEB),
            iconColor: const Color(0xFFF59E0B),
          ),
          _KpiCard(
            title: kpiDiscountsTitle,
            value: kpiDiscounts,
            change: isLive ? 12 : 6,
            sub: kpiDiscountsSub,
            icon: Icons.auto_awesome,
            iconBg: const Color(0xFFFAF5FF),
            iconColor: const Color(0xFF9333EA),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            title: kpiOpeningTitle,
            value: kpiOpening,
            change: isLive ? 0 : -24,
            sub: kpiOpeningSub,
            icon: Icons.inventory_2_outlined,
            iconBg: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _KpiCard(
            title: kpiNearExpiryTitle,
            value: kpiNearExpiry,
            change: isLive ? -16 : -5,
            sub: kpiNearExpirySub,
            icon: Icons.warning_amber_rounded,
            iconBg: const Color(0xFFFFFBEB),
            iconColor: const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _KpiCard(
            title: kpiDiscountsTitle,
            value: kpiDiscounts,
            change: isLive ? 12 : 12,
            sub: kpiDiscountsSub,
            icon: Icons.auto_awesome,
            iconBg: const Color(0xFFFAF5FF),
            iconColor: const Color(0xFF9333EA),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _KpiCard(
            title: kpiDbTitle,
            value: kpiDb,
            change: isLive ? 100 : 18,
            sub: kpiDbSub,
            icon: Icons.cloud_done_outlined,
            iconBg: const Color(0xFFF0FDF4),
            iconColor: const Color(0xFF16A34A),
          ),
        ),
      ],
    );
  }

  Widget _buildFloorplanCard(BuildContext context) {
    return _DashboardCard(
      title: '🗺️ LIVE STORE FLOORPLAN',
      actionText: 'Full Blueprint >',
      onActionTap: () => onNavigateTab?.call(1),
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final aisles = provider.aisles.take(6).toList();

          return Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: aisles.length,
                itemBuilder: (context, index) {
                  final aisle = aisles[index];
                  Color color;
                  if (aisle['status'] == 'critical') {
                    color = const Color(0xFFEF4444);
                  } else if (aisle['status'] == 'expiring') {
                    color = const Color(0xFFF59E0B);
                  } else if (aisle['status'] == 'promo') {
                    color = const Color(0xFF9333EA);
                  } else if (aisle['status'] == 'low') {
                    color = const Color(0xFFEAB308);
                  } else {
                    color = const Color(0xFF16A34A);
                  }

                  return InkWell(
                    onTap: () => _showAislePopup(context, aisle),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        border: Border.all(
                          color: color.withValues(alpha: aisle['status'] == 'critical' ? 0.8 : 0.4),
                          width: aisle['status'] == 'critical' ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text(aisle['id'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(aisle['label'], style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11)),
                          Text('Stock: ${aisle['stock']}', style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildLegendDot(const Color(0xFF16A34A), 'Normal 🟢'),
                    const SizedBox(width: 12),
                    _buildLegendDot(const Color(0xFFEAB308), 'Low 🟡'),
                    const SizedBox(width: 12),
                    _buildLegendDot(const Color(0xFFF59E0B), 'Expiring 🟠'),
                    const SizedBox(width: 12),
                    _buildLegendDot(const Color(0xFFEF4444), 'Critical 🔴'),
                    const SizedBox(width: 12),
                    _buildLegendDot(const Color(0xFF9333EA), 'Promo 🟣'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAislePopup(BuildContext context, Map<String, dynamic> aisle) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('${aisle['id']} · ${aisle['label']}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stock Level: ${aisle['stock']} / ${aisle['maxStock']} units', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Sales Velocity: ${aisle['salesVelocity']} units/hr'),
              const SizedBox(height: 12),
              if (aisle['status'] == 'critical')
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                  child: const Text('⚠️ CRITICAL: Stockout in ~22 min! Restock required.', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AppProvider>().restockAisle(aisle['id']);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✓ Restocked ${aisle['id']}!'), backgroundColor: const Color(0xFF16A34A)),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A), foregroundColor: Colors.white),
              child: const Text('Restock Now'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 11)),
      ],
    );
  }

  Widget _buildAlertsCard(BuildContext context) {
    return _DashboardCard(
      title: '🚨 LIVE URGENT ALERTS',
      actionText: 'Restock Center >',
      onActionTap: () => onNavigateTab?.call(3),
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final alerts = provider.alerts.take(3).toList();

          return Column(
            children: alerts.map((alert) {
              final isCritical = alert['type'] == 'critical';
              final isResolved = alert['status'] == 'resolved';
              final color = isResolved
                  ? const Color(0xFF16A34A)
                  : (isCritical ? const Color(0xFFEF4444) : const Color(0xFFF59E0B));

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 3, right: 10),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  alert['title'] ?? alert['message'],
                                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF0F172A)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(alert['time'] ?? '', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(alert['detail'] ?? '', style: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildSalesWasteChart() {
    return _DashboardCard(
      title: '📈 SALES VS FOOD WASTE (THIS WEEK)',
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    if (value >= 0 && value < days.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(days[value.toInt()], style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              // Sales Trend (Green)
              LineChartBarData(
                spots: const [
                  FlSpot(0, 2.8),
                  FlSpot(1, 2.4),
                  FlSpot(2, 3.1),
                  FlSpot(3, 2.9),
                  FlSpot(4, 3.4),
                  FlSpot(5, 4.1),
                  FlSpot(6, 3.2),
                ],
                isCurved: true,
                color: const Color(0xFF16A34A),
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
              // Waste Trend (Red dashed)
              LineChartBarData(
                spots: const [
                  FlSpot(0, 0.42),
                  FlSpot(1, 0.51),
                  FlSpot(2, 0.38),
                  FlSpot(3, 0.46),
                  FlSpot(4, 0.32),
                  FlSpot(5, 0.29),
                  FlSpot(6, 0.18),
                ],
                isCurved: true,
                color: const Color(0xFFEF4444),
                barWidth: 2,
                dashArray: [4, 4],
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficChart() {
    return _DashboardCard(
      title: '🤖 AI FOOT TRAFFIC FORECAST',
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const hours = ['12:00', '14:00', '16:00', '18:00', '20:00'];
                    if (value >= 0 && value < hours.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(hours[value.toInt()], style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 45),
                  FlSpot(1, 71),
                  FlSpot(2, 80),
                  FlSpot(3, 72),
                  FlSpot(4, 38),
                ],
                isCurved: true,
                color: const Color(0xFF2563EB),
                barWidth: 2.5,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final int change;
  final String sub;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.change,
    required this.sub,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isPos = change > 0;
    final color = isPos ? const Color(0xFF16A34A) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(isPos ? Icons.arrow_upward : Icons.arrow_downward, size: 11, color: color),
                    const SizedBox(width: 2),
                    Text('${change.abs()}%', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          Text(title, style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 12)),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Widget child;

  const _DashboardCard({
    required this.title,
    this.actionText,
    this.onActionTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: const Color(0xFF334155),
                    letterSpacing: 0.5,
                  ),
                ),
                if (actionText != null)
                  InkWell(
                    onTap: onActionTap,
                    child: Text(
                      actionText!,
                      style: GoogleFonts.inter(color: const Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }
}
