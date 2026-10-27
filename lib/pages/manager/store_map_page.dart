import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../data/mock_data.dart';

class StoreMapPage extends StatelessWidget {
  const StoreMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Overview
          _buildMapHeader(context),
          const SizedBox(height: 20),

          // Legend Bar
          _buildLegendBar(),
          const SizedBox(height: 24),

          // 2D Store Layout Blueprint Card
          _buildFloorplanLayout(context),
          const SizedBox(height: 24),

          // Zone Breakdown Stats
          _buildZoneStats(context),
        ],
      ),
    );
  }

  Widget _buildMapHeader(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('🗺️', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interactive 2D Store Floorplan',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Store #001 · Central Bangkok · Real-time aisle inventory & anomaly detection',
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

  Widget _buildLegendBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildLegendItem(const Color(0xFF16A34A), 'Normal Stock (🟢)'),
          _buildLegendItem(const Color(0xFFEAB308), 'Low Stock (🟡)'),
          _buildLegendItem(const Color(0xFFF59E0B), 'Expiring Soon (🟠)'),
          _buildLegendItem(const Color(0xFFEF4444), 'Critical Restock (🔴)'),
          _buildLegendItem(const Color(0xFF9333EA), 'Promo / Flash Deal (🟣)'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _buildFloorplanLayout(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final aisles = provider.aisles;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Store Entrance Marker
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🚪 ', style: TextStyle(fontSize: 16)),
                    Text(
                      'MAIN ENTRANCE & WELCOME ZONE',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Aisle Grid: 3 rows of 3 columns
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 600;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 2 : 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isMobile ? 1.2 : 1.5,
                    ),
                    itemCount: aisles.length,
                    itemBuilder: (context, index) {
                      final aisle = aisles[index];
                      return _buildAisleCard(context, aisle);
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Checkout Area Marker
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🛒 🛒 🛒 ', style: TextStyle(fontSize: 18)),
                    Text(
                      'EXPRESS CHECKOUT & POS TERMINALS 1 - 4',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAisleCard(BuildContext context, Map<String, dynamic> aisle) {
    final status = aisle['status'] ?? 'normal';
    final stock = (aisle['stock'] as num).toInt();
    final maxStock = (aisle['maxStock'] as num).toInt();
    final velocity = (aisle['salesVelocity'] as num).toDouble();

    Color statusColor;
    Color bgColor;
    String statusBadge;

    if (status == 'critical') {
      statusColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEF2F2);
      statusBadge = '🔴 RESTOCK NOW';
    } else if (status == 'expiring') {
      statusColor = const Color(0xFFF59E0B);
      bgColor = const Color(0xFFFFFBEB);
      statusBadge = '🟠 EXPIRING';
    } else if (status == 'promo') {
      statusColor = const Color(0xFF9333EA);
      bgColor = const Color(0xFFFAF5FF);
      statusBadge = '🟣 FLASH DEAL';
    } else if (status == 'low') {
      statusColor = const Color(0xFFEAB308);
      bgColor = const Color(0xFFFEFCE8);
      statusBadge = '🟡 LOW STOCK';
    } else {
      statusColor = const Color(0xFF16A34A);
      bgColor = const Color(0xFFF0FDF4);
      statusBadge = '🟢 NORMAL';
    }

    return InkWell(
      onTap: () => _showAisleDetailsModal(context, aisle),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: statusColor.withValues(alpha: status == 'critical' ? 0.8 : 0.4),
            width: status == 'critical' ? 2 : 1,
          ),
          boxShadow: status == 'critical'
              ? [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(aisle['icon'] ?? '📦', style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      aisle['id'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusBadge,
                    style: GoogleFonts.inter(
                      color: statusColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aisle['label'],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Stock: $stock / $maxStock  ·  $velocity/hr',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (stock / maxStock).clamp(0.0, 1.0),
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAisleDetailsModal(BuildContext context, Map<String, dynamic> aisle) {
    final product = productsData.firstWhere(
      (p) => p['id'] == aisle['productId'],
      orElse: () => {'name': aisle['label'], 'emoji': '📦', 'price': 50.0, 'category': 'General'},
    );

    final stock = (aisle['stock'] as num).toInt();
    final velocity = (aisle['salesVelocity'] as num).toDouble();
    final stockoutMins = velocity > 0 ? ((stock / velocity) * 60).round() : 999;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(product['emoji'] ?? '📦', style: const TextStyle(fontSize: 30)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${aisle['id']} · ${product['name']}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${product['category']} · ${aisle['zone']}',
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
              const SizedBox(height: 20),

              // Metrics Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMetricCol('Current Stock', '$stock / ${aisle['maxStock']} units'),
                        _buildMetricCol('Sales Velocity', '$velocity units / hr'),
                        _buildMetricCol('Unit Price', '฿${product['price']}'),
                      ],
                    ),
                    const Divider(height: 24, color: Color(0xFFE2E8F0)),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Color(0xFFEF4444), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            stockoutMins < 60
                                ? '⚠️ Stockout estimated in ~$stockoutMins minutes!'
                                : 'Stockout estimated in ~${(stockoutMins / 60).toStringAsFixed(1)} hours.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: stockoutMins < 60 ? const Color(0xFFEF4444) : const Color(0xFF16A34A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('📢 Alert sent to floor staff Alex for ${aisle['id']}!'),
                            backgroundColor: const Color(0xFF0F172A),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Notify Staff'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<AppProvider>().restockAisle(aisle['id']);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✓ ${aisle['id']} restocked to full capacity!'),
                            backgroundColor: const Color(0xFF16A34A),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('Restock Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
      ],
    );
  }

  Widget _buildZoneStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Floorplan Zone Summary',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildZoneCard('Chilled Zone A', 'Dairy & Milk', '1 Critical Alert', const Color(0xFFEF4444))),
              const SizedBox(width: 12),
              Expanded(child: _buildZoneCard('Ready Meal C', 'Sushi & Salads', '2 Active Promos', const Color(0xFF9333EA))),
              const SizedBox(width: 12),
              Expanded(child: _buildZoneCard('Bakery F', 'Croissants', '1 Expiring Batch', const Color(0xFFF59E0B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard(String zone, String category, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(zone, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          Text(category, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
          const SizedBox(height: 8),
          Text(status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
