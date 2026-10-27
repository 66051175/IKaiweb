import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../data/mock_data.dart';

class StaffInventoryPage extends StatelessWidget {
  const StaffInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final aisles = provider.aisles;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shelf Replenishment Checklist',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap + to add stock or Restock to fill shelf completely.',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              ...aisles.map((aisle) {
                final product = productsData.firstWhere(
                  (p) => p['id'] == aisle['productId'],
                  orElse: () => {'name': aisle['label'], 'emoji': '📦'},
                );
                final stock = (aisle['stock'] as num).toInt();
                final maxStock = (aisle['maxStock'] as num).toInt();
                final isCritical = aisle['status'] == 'critical';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isCritical ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
                      width: isCritical ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(product['emoji'] ?? '📦', style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${aisle['id']} · ${product['name']}',
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF0F172A)),
                            ),
                            Text('Stock: $stock / $maxStock', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          provider.restockAisle(aisle['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✓ Replenished ${aisle['id']}!'),
                              backgroundColor: const Color(0xFF16A34A),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCritical ? const Color(0xFFEF4444) : const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('Restock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
