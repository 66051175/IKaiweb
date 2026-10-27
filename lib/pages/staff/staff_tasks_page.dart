import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../data/mock_data.dart';

class StaffTasksPage extends StatelessWidget {
  const StaffTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final openAlerts = provider.alerts.where((a) => a['status'] != 'resolved').toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Staff Greeting Banner
              _buildStaffGreeting(context),
              const SizedBox(height: 16),

              // Task Count Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🚨 ', style: TextStyle(fontSize: 18)),
                      Text(
                        '${openAlerts.length} PENDING TASKS',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 0.8,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'AI Floor Dispatch',
                    style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (openAlerts.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 54),
                      const SizedBox(height: 12),
                      Text(
                        'All tasks completed!',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Great job, Alex! All aisles are stocked and clearance tags are placed.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                )
              else
                ...openAlerts.map((alert) {
                  final isCritical = alert['type'] == 'critical';
                  final aisleId = alert['aisleId'];
                  final aisle = provider.aisles.firstWhere(
                    (a) => a['id'] == aisleId,
                    orElse: () => {'stock': 3, 'maxStock': 40, 'salesVelocity': 8.0},
                  );
                  final product = productsData.firstWhere(
                    (p) => p['id'] == alert['productId'],
                    orElse: () => {'name': alert['title'] ?? 'Product', 'emoji': '📦'},
                  );

                  return _buildTaskCard(context, provider, alert, aisle, product, isCritical);
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStaffGreeting(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;
    final userName = user?['name'] ?? 'Alex';
    final userBranch = user?['branch'] ?? 'Store #001';
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'A';

    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF16A34A),
            radius: 22,
            child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good afternoon, $userName 🧑‍🔧',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Floor Staff · $userBranch',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    AppProvider provider,
    Map<String, dynamic> alert,
    Map<String, dynamic> aisle,
    Map<String, dynamic> product,
    bool isCritical,
  ) {
    final color = isCritical ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: isCritical ? 0.8 : 0.4),
          width: isCritical ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(
                      isCritical ? '🔴 URGENT RESTOCK' : '🟠 SHELF CHECK',
                      style: GoogleFonts.inter(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                alert['time'] ?? 'Just now',
                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Text(product['emoji'] ?? '📦', style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${alert['aisleId']} · ${product['name']}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isCritical
                          ? 'Only ${aisle['stock']} left · Est. stockout ~${alert['estimatedMinutes'] ?? 22} min'
                          : '${alert['detail'] ?? alert['message']}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF475569),
                        fontWeight: isCritical ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Primary Big Button for Phone Tap
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                provider.restockAisle(alert['aisleId']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ Restocked ${alert['aisleId']} (${product['name']})! Store floorplan updated to 🟢 Normal.'),
                    backgroundColor: const Color(0xFF16A34A),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: Text(
                isCritical ? 'RESTOCK NOW (✓ MARK DONE)' : 'CHECK & CONFIRM ✓',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCritical ? const Color(0xFFEF4444) : const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
