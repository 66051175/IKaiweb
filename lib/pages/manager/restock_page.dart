import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../data/mock_data.dart';

class RestockPage extends StatefulWidget {
  const RestockPage({super.key});

  @override
  State<RestockPage> createState() => _RestockPageState();
}

class _RestockPageState extends State<RestockPage> {
  String _selectedFilter = 'all'; // all, critical, warning, resolved

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Formula Banner (AI Stockout Estimation)
          _buildFormulaBanner(),
          const SizedBox(height: 20),

          // Header & Stats
          _buildStatsRow(context),
          const SizedBox(height: 24),

          // Filter Chips
          _buildFilterChips(),
          const SizedBox(height: 16),

          // Restock Alerts List
          _buildAlertsList(context),
        ],
      ),
    );
  }

  Widget _buildFormulaBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '⚡ RESTOCK AI ALGORITHM',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              const Text('Live Calculation', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Estimated Stockout Time = Current Stock ÷ Sales Velocity',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Example (Aisle 4 Milk): 3 units ÷ 8 units/hour = 0.375 hr ≈ 22.5 minutes until empty shelf.',
            style: GoogleFonts.inter(
              color: const Color(0xFFCBD5E1),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final criticalCount = provider.alerts.where((a) => a['status'] != 'resolved' && a['type'] == 'critical').length;
        final warningCount = provider.alerts.where((a) => a['status'] != 'resolved' && a['type'] == 'warning').length;
        final resolvedCount = provider.alerts.where((a) => a['status'] == 'resolved').length;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 520;
            if (isNarrow) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 150, child: _buildSummaryCard('🔴 Critical Restock', '$criticalCount Aisles', const Color(0xFFEF4444))),
                    const SizedBox(width: 10),
                    SizedBox(width: 150, child: _buildSummaryCard('🟠 Low / Expiring', '$warningCount Aisles', const Color(0xFFF59E0B))),
                    const SizedBox(width: 10),
                    SizedBox(width: 150, child: _buildSummaryCard('🟢 Restocked Today', '$resolvedCount Items', const Color(0xFF16A34A))),
                  ],
                ),
              );
            }
            return Row(
              children: [
                Expanded(child: _buildSummaryCard('🔴 Critical Restock', '$criticalCount Aisles', const Color(0xFFEF4444))),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('🟠 Low / Expiring', '$warningCount Aisles', const Color(0xFFF59E0B))),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('🟢 Restocked Today', '$resolvedCount Items', const Color(0xFF16A34A))),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('all', 'All Alerts'),
          const SizedBox(width: 8),
          _buildChip('critical', '🔴 Critical'),
          const SizedBox(width: 8),
          _buildChip('warning', '🟠 Warning'),
          const SizedBox(width: 8),
          _buildChip('resolved', '🟢 Resolved'),
        ],
      ),
    );
  }

  Widget _buildChip(String id, String label) {
    final isSelected = _selectedFilter == id;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = id),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsList(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        var alerts = provider.alerts;
        if (_selectedFilter == 'critical') {
          alerts = alerts.where((a) => a['type'] == 'critical' && a['status'] != 'resolved').toList();
        } else if (_selectedFilter == 'warning') {
          alerts = alerts.where((a) => (a['type'] == 'warning' || a['type'] == 'ai') && a['status'] != 'resolved').toList();
        } else if (_selectedFilter == 'resolved') {
          alerts = alerts.where((a) => a['status'] == 'resolved').toList();
        }

        if (alerts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle_outline, size: 48, color: Color(0xFF16A34A)),
                const SizedBox(height: 12),
                Text(
                  'No pending alerts in this category!',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                ),
                Text('All shelves in this zone are currently well stocked.', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B))),
              ],
            ),
          );
        }

        return Column(
          children: alerts.map((alert) {
            final isResolved = alert['status'] == 'resolved';
            final isCritical = alert['type'] == 'critical';
            final color = isResolved
                ? const Color(0xFF16A34A)
                : (isCritical ? const Color(0xFFEF4444) : const Color(0xFFF59E0B));

            // Find product
            final product = productsData.firstWhere(
              (p) => p['id'] == alert['productId'],
              orElse: () => {'name': alert['title'] ?? 'Product', 'emoji': '📦', 'salesVelocity': 5.0},
            );

            // Find aisle
            final aisle = provider.aisles.firstWhere(
              (a) => a['id'] == alert['aisleId'],
              orElse: () => {'stock': 3, 'maxStock': 40, 'salesVelocity': 8.0},
            );

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCritical && !isResolved ? const Color(0xFFEF4444).withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
                  width: isCritical && !isResolved ? 1.5 : 1,
                ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(product['emoji'] ?? '📦', style: const TextStyle(fontSize: 26)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    alert['title'] ?? product['name'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isResolved ? '✓ RESOLVED' : (isCritical ? '🔴 CRITICAL' : '🟠 WARNING'),
                                    style: GoogleFonts.inter(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alert['detail'] ?? alert['message'],
                              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF475569)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Metrics line
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Stock: ${aisle['stock']} / ${aisle['maxStock']} units',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
                        ),
                        Text(
                          'Velocity: ${aisle['salesVelocity']} units/hr',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                        ),
                        if (alert['estimatedMinutes'] != null && !isResolved)
                          Text(
                            'Est. Stockout: ~${alert['estimatedMinutes']} mins',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444)),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (!isResolved) ...[
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('📢 Restock notification pushed to Staff Alex mobile app for ${alert['aisleId']}!'),
                                backgroundColor: const Color(0xFF0F172A),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications_active_outlined, size: 16),
                          label: const Text('Send Staff Alert'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F172A),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            provider.restockAisle(alert['aisleId']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('✓ Marked ${alert['aisleId']} as restocked! Floorplan updated to 🟢 Normal.'),
                                backgroundColor: const Color(0xFF16A34A),
                              ),
                            );
                          },
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Mark as Restocked ✓'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Resolved by Staff Alex · ${alert['time']}',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF16A34A), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
