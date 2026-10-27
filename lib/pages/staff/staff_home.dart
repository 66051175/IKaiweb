import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import 'staff_tasks_page.dart';
import 'staff_inventory_page.dart';
import 'staff_notifications_page.dart';

class StaffHome extends StatefulWidget {
  const StaffHome({super.key});

  @override
  State<StaffHome> createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    StaffTasksPage(),
    StaffInventoryPage(),
    StaffNotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final alertCount = context.watch<AppProvider>().alerts.where((a) => a['status'] != 'resolved').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(8)),
              child: const Text('🌱', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 8),
            Text(
              'FreshFlow Staff',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF0F172A)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Color(0xFF16A34A)),
            tooltip: 'Switch Role',
            onPressed: () {
              context.read<AppProvider>().setRole(null);
              context.go('/login');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _buildScenarioBar(context),
        ),
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: alertCount > 0,
              label: Text('$alertCount'),
              child: const Icon(Icons.checklist_rounded),
            ),
            label: 'My Tasks',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF16A34A),
        unselectedItemColor: const Color(0xFF64748B),
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }

  Widget _buildScenarioBar(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final step = provider.demoScenarioStep;

    return Container(
      height: 40,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text('🎬 SCENARIO:', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            _buildStepBtn('Reset', 'Default', step == 0, () => provider.applyScenarioStep(0)),
            _buildStepBtn('19:00', 'Milk 🔴 (Stock 3)', step == 3, () => provider.applyScenarioStep(3)),
            _buildStepBtn('✓', 'Restock Alex 🟢', step == 4, () => provider.applyScenarioStep(4)),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBtn(String time, String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF16A34A) : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: active ? const Color(0xFF16A34A) : Colors.white24),
        ),
        child: Text(
          '$time $label',
          style: TextStyle(color: active ? Colors.white : const Color(0xFFCBD5E1), fontSize: 10, fontWeight: active ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }
}
