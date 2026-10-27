import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../data/mock_data.dart';

class DynamicPricingPage extends StatelessWidget {
  const DynamicPricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & How AI Works Banner
          _buildEngineHeader(),
          const SizedBox(height: 20),

          // Weather & Real-time Context Ribbon
          _buildContextRibbon(),
          const SizedBox(height: 24),

          // Dynamic Pricing Cards
          _buildPricingCardsList(context),
        ],
      ),
    );
  }

  Widget _buildEngineHeader() {
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
              color: const Color(0xFF9333EA).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('🏷️', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dynamic Discount Engine',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI calculates optimal clearance discounts based on Expiry, Velocity, Foot Traffic, and Weather to maximize revenue and eliminate food waste.',
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

  Widget _buildContextRibbon() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildContextItem('🌦️ Weather', 'Heavy Rain (Bangkok)'),
            const SizedBox(width: 24),
            _buildContextItem('👥 Foot Traffic', '35% (-35% rain effect)'),
            const SizedBox(width: 24),
            _buildContextItem('⏰ Current Time', '18:00 (Dinner Peak)'),
            const SizedBox(width: 24),
            _buildContextItem('🎯 Optimization Goal', 'Zero Food Waste'),
          ],
        ),
      ),
    );
  }

  Widget _buildContextItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildPricingCardsList(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final discounts = provider.discounts;

        return Column(
          children: discounts.map((deal) {
            final product = productsData.firstWhere(
              (p) => p['id'] == deal['productId'],
              orElse: () => {
                'name': deal['productName'] ?? deal['name'] ?? 'Product ${deal['productId']}',
                'emoji': deal['emoji'] ?? '🍱',
                'category': deal['category'] ?? 'Food',
              },
            );

            final originalPrice = (deal['originalPrice'] as num).toDouble();
            final finalPrice = (deal['finalPrice'] as num).toDouble();
            final discountPercent = (deal['discountPercent'] as num).toInt();
            final aiInputs = deal['aiInputs'] as Map<String, dynamic>? ?? {};

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Header Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(product['emoji'] ?? '🍱', style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              '${product['category']} · ${deal['aisleId'] ?? 'Aisle 3'} · Current Stock: ${deal['stock']} units',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Current Price Pill
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '฿${finalPrice.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '฿${originalPrice.toStringAsFixed(0)}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF94A3B8),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9333EA).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$discountPercent% OFF',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF9333EA),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // AI Input Breakdown Grid
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
                        Text(
                          'AI PRICING INPUT VARIABLES',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildInputCell('Expires In', '${deal['expiryMinutes']} mins', const Color(0xFFF59E0B)),
                              const SizedBox(width: 16),
                              _buildInputCell('Current Stock', '${deal['stock']} units', const Color(0xFF0F172A)),
                              const SizedBox(width: 16),
                              _buildInputCell('Sales Velocity', aiInputs['salesVelocity'] ?? '5/hr', const Color(0xFF0F172A)),
                              const SizedBox(width: 16),
                              _buildInputCell('Forecast Traffic', aiInputs['traffic'] ?? '35%', const Color(0xFF2563EB)),
                              const SizedBox(width: 16),
                              _buildInputCell('Weather', aiInputs['weather'] ?? '🌧️ Rain', const Color(0xFF2563EB)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // AI Recommendation & Outcome Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🤖 ', style: TextStyle(fontSize: 18)),
                            Expanded(
                              child: Text(
                                'AI Recommendation: $discountPercent% OFF NOW',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF166534),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Waste Risk: ${deal['wasteProbability'] ?? 8}%',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          deal['aiReasoning'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Expected sell-through: ${deal['expectedSold']} / ${deal['stock']} units before expiry.',
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF166534)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons (Adjust or Apply)
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          // Quick increment discount by 10%
                          final newDiscount = (discountPercent + 10).clamp(10, 80);
                          provider.applyDiscount(deal['id'], newDiscount);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('+10% Boost'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          provider.applyDiscount(deal['id'], discountPercent);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✓ Dynamic discount $discountPercent% OFF active for ${product['name']}!'),
                              backgroundColor: const Color(0xFF16A34A),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bolt, size: 18),
                        label: const Text('Apply AI Discount'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
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

  Widget _buildInputCell(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}
