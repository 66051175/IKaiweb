import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../data/mock_data.dart';
import 'deal_detail_modal.dart';

class SavedDealsPage extends StatelessWidget {
  const SavedDealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final savedIds = provider.savedDealIds;
        final vouchers = provider.claimedVouchers;
        final savedDeals = provider.discounts.where((d) => savedIds.contains(d['id'])).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Claimed Vouchers Section
              Text(
                '🎟️ My Claimed QR Vouchers (${vouchers.length})',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),

              if (vouchers.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code, color: Color(0xFF94A3B8), size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'No claimed vouchers yet. Tap "Claim Deal" on any flash item to get your discount QR code!',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...vouchers.map((vouch) {
                  final product = productsData.firstWhere(
                    (p) => p['id'] == vouch['productId'],
                    orElse: () => {'name': 'Product', 'emoji': '🍱'},
                  );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.qr_code_2, size: 40, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product['emoji']} ${product['name']}',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                              ),
                              Text('Voucher: ${vouch['id']} · ฿${vouch['finalPrice']}', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF86EFAC), fontWeight: FontWeight.bold)),
                              Text('Show to cashier · Exp in ${vouch['expiresIn']}', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 24),

              // Saved Bookmarks Section
              Text(
                '❤️ Saved Flash Deals (${savedDeals.length})',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),

              if (savedDeals.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text('No bookmarked deals.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                )
              else
                ...savedDeals.map((deal) {
                  final product = productsData.firstWhere(
                    (p) => p['id'] == deal['productId'],
                    orElse: () => {'name': 'Product', 'emoji': '🍱', 'category': 'Food'},
                  );
                  final aisle = provider.aisles.firstWhere(
                    (a) => a['productId'] == deal['productId'],
                    orElse: () => {'name': 'Aisle 3'},
                  );

                  return InkWell(
                    onTap: () => DealDetailModal.show(context, deal: deal, product: product, aisle: aisle),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Text(product['emoji'] ?? '🍱', style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product['name'], style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF0F172A))),
                                Text('฿${deal['finalPrice']} (${deal['discountPercent']}% OFF)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444))),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Color(0xFFEF4444)),
                            onPressed: () => provider.toggleSaveDeal(deal['id']),
                          ),
                        ],
                      ),
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
