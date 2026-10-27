import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';

class DealDetailModal extends StatelessWidget {
  final Map<String, dynamic> deal;
  final Map<String, dynamic> product;
  final Map<String, dynamic> aisle;

  const DealDetailModal({
    super.key,
    required this.deal,
    required this.product,
    required this.aisle,
  });

  static void show(
    BuildContext context, {
    required Map<String, dynamic> deal,
    required Map<String, dynamic> product,
    required Map<String, dynamic> aisle,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DealDetailModal(deal: deal, product: product, aisle: aisle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final originalPrice = (deal['originalPrice'] as num).toInt();
    final finalPrice = (deal['finalPrice'] as num).toInt();
    final discountPercent = deal['discountPercent'];
    final stock = deal['stock'] ?? 8;
    final minsLeft = deal['expiryMinutes'] ?? 102;
    final hoursStr = (minsLeft ~/ 60).toString().padLeft(2, '0');
    final minsStr = (minsLeft % 60).toString().padLeft(2, '0');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),

            // Product Image & Name
            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(product['emoji'] ?? '🍣', style: const TextStyle(fontSize: 40)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? 'Fresh Salmon Sushi',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${product['category']} · ${aisle['name'] ?? 'Aisle 3'}',
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 14),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              'FreshFlow Store #001 (Central Bangkok)',
                              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Price & Discount Callout
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '฿$finalPrice',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFEF4444),
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '฿$originalPrice',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color(0xFF94A3B8),
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '🔥 $discountPercent% FLASH DISCOUNT',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Limited Stock', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                      Text(
                        'Only $stock left!',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Expiration Date & Countdown Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.event_busy, color: Color(0xFFD97706), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'วันหมดอายุ / Best-Before Date',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF92400E)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              deal['expiryFormatted'] ?? product['expiryFormatted'] ?? 'Today · 19:42',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF78350F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: Color(0xFFFDE68A)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.alarm, color: Color(0xFFD97706), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'ระยะเวลาคงเหลือ:',
                            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF92400E)),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$hoursStr : $minsStr : 45',
                          style: GoogleFonts.robotoMono(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Why this deal? Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🌱 ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Why this deal?',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This gourmet product is approaching its best-before window. By claiming this deal, you save 40% while preventing good food from being wasted!',
                    style: GoogleFonts.inter(fontSize: 12, height: 1.4, color: const Color(0xFF475569)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Claim Deal Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final voucher = context.read<AppProvider>().claimDeal(deal['id']);
                  Navigator.pop(context);
                  if (voucher != null) {
                    _showVoucherSuccessDialog(context, voucher, product);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'CLAIM DEAL (GET QR VOUCHER)',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showVoucherSuccessDialog(BuildContext context, Map<String, dynamic> voucher, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'Deal Claimed Successfully! 🎉',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Show this QR barcode at the store cashier to redeem your ฿${voucher['finalPrice']} price.',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Mock QR Code Box
              Container(
                width: 160,
                height: 160,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_2, size: 100, color: Color(0xFF0F172A)),
                    Text(
                      voucher['id'] ?? 'VOUCH-8821',
                      style: GoogleFonts.robotoMono(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text('Valid for ${voucher['expiresIn']} at Store #001', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Saved in My Vouchers ✓'),
              ),
            ),
          ],
        );
      },
    );
  }
}
