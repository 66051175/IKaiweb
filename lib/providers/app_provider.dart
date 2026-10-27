import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../services/api_service.dart';

class AppProvider with ChangeNotifier {
  String? role; // 'manager', 'staff', 'customer'
  Map<String, dynamic>? currentUser;

  // Backend Integration State
  bool isBackendOnline = false;
  bool isSyncingBackend = false;
  String backendStatusMessage = 'Offline (Using Mock Data)';
  Map<String, dynamic>? backendDashboardSummary;
  List<Map<String, dynamic>> backendInventory = [];
  List<Map<String, dynamic>> backendRecommendations = [];
  List<Map<String, dynamic>> backendDeals = [];

  AppProvider() {
    // Proactively check backend connection on app launch
    checkBackendConnection();
  }

  List<Map<String, dynamic>> registeredUsers = [
    {
      'id': 'u1',
      'name': 'Somchai Jaidee',
      'email': 'manager@freshflow.ai',
      'role': 'manager',
      'branch': 'FreshFlow Store #001 (Central Bangkok)',
      'phone': '081-234-5678',
    },
    {
      'id': 'u2',
      'name': 'Alex Rivera',
      'email': 'staff@freshflow.ai',
      'role': 'staff',
      'branch': 'FreshFlow Store #001 (Central Bangkok)',
      'phone': '089-876-5432',
    },
    {
      'id': 'u3',
      'name': 'Nattaporn S.',
      'email': 'customer@freshflow.ai',
      'role': 'customer',
      'branch': 'FreshFlow Store #001 (Central Bangkok)',
      'phone': '092-111-2233',
    },
  ];
  
  List<Map<String, dynamic>> aisles = List.from(aislesData);
  List<Map<String, dynamic>> alerts = List.from(alertsData);
  List<Map<String, dynamic>> discounts = List.from(discountsData);
  List<Map<String, dynamic>> notifications = List.from(notificationsData);
  
  final Set<String> savedDealIds = {'d1', 'd2'};
  final List<Map<String, dynamic>> claimedVouchers = [];
  
  int demoScenarioStep = 0; // 0: Normal, 1: 16:00, 2: 18:00 Rain, 3: 19:00 Stockout, 4: Restocked, 5: Summary

  void setRole(String? newRole) {
    role = newRole;
    if (newRole != null) {
      currentUser = registeredUsers.firstWhere(
        (u) => u['role'] == newRole,
        orElse: () => {
          'name': newRole == 'manager' ? 'Somchai Jaidee' : (newRole == 'staff' ? 'Alex Rivera' : 'Shopper'),
          'role': newRole,
          'email': '$newRole@freshflow.ai',
          'branch': 'FreshFlow Store #001 (Central Bangkok)',
        },
      );
    } else {
      currentUser = null;
    }
    notifyListeners();
  }

  // Invitation & Employee verification codes
  final List<String> validManagerCodes = ['FF-MGR-001', 'FF-MGR-002', 'FF-MGR-003', 'ADMIN2026', 'MGR'];
  final List<String> validStaffCodes = ['FF-STAFF-001', 'FF-STAFF-002', 'FF-STAFF-003', 'STAFF2026', 'STF'];

  // Register new Employee (Manager or Staff) with security code validation
  Map<String, dynamic> registerEmployee({
    required String name,
    required String email,
    required String password,
    required String role, // 'manager' or 'staff'
    required String branch,
    required String code,
  }) {
    final cleanCode = code.trim().toUpperCase();

    if (role == 'manager') {
      final isValid = validManagerCodes.contains(cleanCode) || cleanCode.startsWith('FF-MGR-') || cleanCode == 'ADMIN';
      if (!isValid) {
        return {
          'success': false,
          'message': 'Invalid Manager Invitation Code. Try "FF-MGR-001" (รหัสผู้จัดการไม่ถูกต้อง กรุณาใช้ FF-MGR-001)',
        };
      }
    } else if (role == 'staff') {
      final isValid = validStaffCodes.contains(cleanCode) || cleanCode.startsWith('FF-STAFF-') || cleanCode == 'STAFF';
      if (!isValid) {
        return {
          'success': false,
          'message': 'Invalid Staff Employee Code. Try "FF-STAFF-001" (รหัสพนักงานไม่ถูกต้อง กรุณาใช้ FF-STAFF-001)',
        };
      }
    }

    final newUser = {
      'id': 'u-${DateTime.now().millisecondsSinceEpoch}',
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      'role': role,
      'branch': branch,
      'employeeCode': cleanCode,
      'createdAt': DateTime.now(),
    };

    registeredUsers.insert(0, newUser);
    currentUser = newUser;
    this.role = role;

    notifications.insert(0, {
      'id': 'n-emp-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'ai',
      'title': 'New Employee Registered: $name ($role)',
      'detail': 'Assigned to $branch with code $cleanCode.',
      'time': 'Just now',
      'unread': true,
    });

    notifyListeners();
    return {'success': true, 'user': newUser};
  }

  // Register Customer (Shop & Save Food)
  Map<String, dynamic> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    final newUser = {
      'id': 'u-${DateTime.now().millisecondsSinceEpoch}',
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'phone': phone.trim(),
      'password': password,
      'role': 'customer',
      'branch': 'FreshFlow Store #001 (Central Bangkok)',
      'createdAt': DateTime.now(),
    };

    registeredUsers.insert(0, newUser);
    currentUser = newUser;
    role = 'customer';

    notifications.insert(0, {
      'id': 'n-cust-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'ai',
      'title': 'New Customer Joined: $name',
      'detail': 'Welcome to FreshFlow Flash Deals & Food Waste community!',
      'time': 'Just now',
      'unread': true,
    });

    notifyListeners();
    return {'success': true, 'user': newUser};
  }

  // Legacy fallback
  bool registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    String? branch,
    String? phone,
  }) {
    if (role == 'customer') {
      return registerCustomer(name: name, email: email, phone: phone ?? '', password: password)['success'] == true;
    } else {
      return registerEmployee(name: name, email: email, password: password, role: role, branch: branch ?? 'FreshFlow #001', code: role == 'manager' ? 'FF-MGR-001' : 'FF-STAFF-001')['success'] == true;
    }
  }

  // Login existing user
  bool loginUser(String email, String password) {
    final cleanEmail = email.trim().toLowerCase();
    final user = registeredUsers.firstWhere(
      (u) => u['email'] == cleanEmail,
      orElse: () => {
        'name': 'Demo User',
        'email': cleanEmail,
        'role': cleanEmail.contains('staff') ? 'staff' : (cleanEmail.contains('customer') ? 'customer' : 'manager'),
        'branch': 'FreshFlow Store #001 (Central Bangkok)',
      },
    );

    currentUser = user;
    role = user['role'] as String;
    notifyListeners();
    return true;
  }

  // Restock an aisle by ID (used by both Manager and Staff)
  void restockAisle(String aisleId, {int newStock = 40}) {
    for (int i = 0; i < aisles.length; i++) {
      if (aisles[i]['id'] == aisleId) {
        final maxStock = (aisles[i]['maxStock'] as num?)?.toInt() ?? 40;
        aisles[i] = {
          ...aisles[i],
          'status': 'normal',
          'stock': newStock > maxStock ? maxStock : newStock,
        };
      }
    }

    // Resolve any open alerts for this aisle
    for (int i = 0; i < alerts.length; i++) {
      if (alerts[i]['aisleId'] == aisleId && alerts[i]['status'] != 'resolved') {
        alerts[i] = {
          ...alerts[i],
          'status': 'resolved',
          'detail': 'Restocked successfully by Staff Alex.',
        };
      }
    }

    // Add resolved notification
    notifications.insert(0, {
      'id': 'n-restock-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'resolved',
      'title': 'Restock Completed — $aisleId',
      'detail': 'Display replenished to full capacity.',
      'time': 'Just now',
      'unread': true,
    });

    notifyListeners();
  }

  // Adjust stock count manually
  void adjustStock(String aisleId, int delta) {
    for (int i = 0; i < aisles.length; i++) {
      if (aisles[i]['id'] == aisleId) {
        final current = (aisles[i]['stock'] as num).toInt();
        final maxStock = (aisles[i]['maxStock'] as num).toInt();
        final updated = (current + delta).clamp(0, maxStock);
        
        String newStatus = aisles[i]['status'];
        if (updated <= 5) {
          newStatus = 'critical';
        } else if (updated <= 10) {
          newStatus = 'low';
        } else if (newStatus == 'critical' || newStatus == 'low') {
          newStatus = 'normal';
        }

        aisles[i] = {
          ...aisles[i],
          'stock': updated,
          'status': newStatus,
        };
      }
    }
    notifyListeners();
  }

  // Apply or update dynamic discount
  void applyDiscount(String dealId, int discountPercent) {
    for (int i = 0; i < discounts.length; i++) {
      if (discounts[i]['id'] == dealId) {
        final original = (discounts[i]['originalPrice'] as num).toDouble();
        final finalPrice = original * (1 - (discountPercent / 100));
        discounts[i] = {
          ...discounts[i],
          'discountPercent': discountPercent,
          'finalPrice': (finalPrice * 10).round() / 10,
          'status': 'active',
        };

        // Also update aisle status to promo
        final aisleId = discounts[i]['aisleId'];
        if (aisleId != null) {
          for (int a = 0; a < aisles.length; a++) {
            if (aisles[a]['id'] == aisleId) {
              aisles[a] = {
                ...aisles[a],
                'status': 'promo',
              };
            }
          }
        }
      }
    }

    notifications.insert(0, {
      'id': 'n-disc-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'ai',
      'title': 'AI Pricing Activated: $discountPercent% OFF',
      'detail': 'Updated in POS and published to Customer Feed.',
      'time': 'Just now',
      'unread': true,
    });

    notifyListeners();
  }

  // Toggle Save Deal bookmark
  void toggleSaveDeal(String dealId) {
    if (savedDealIds.contains(dealId)) {
      savedDealIds.remove(dealId);
    } else {
      savedDealIds.add(dealId);
    }
    notifyListeners();
  }

  // Claim Deal Voucher
  Map<String, dynamic>? claimDeal(String dealId) {
    for (int i = 0; i < discounts.length; i++) {
      if (discounts[i]['id'] == dealId) {
        final currentStock = (discounts[i]['stock'] as num).toInt();
        if (currentStock > 0) {
          discounts[i] = {
            ...discounts[i],
            'stock': currentStock - 1,
          };
        }

        final voucher = {
          'id': 'VOUCH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'dealId': dealId,
          'productId': discounts[i]['productId'],
          'discountPercent': discounts[i]['discountPercent'],
          'finalPrice': discounts[i]['finalPrice'],
          'claimedAt': DateTime.now(),
          'expiresIn': '${discounts[i]['expiryMinutes']} min',
          'qrCode': 'FRESH-${discounts[i]['productId']}-${DateTime.now().millisecondsSinceEpoch}',
        };

        claimedVouchers.insert(0, voucher);
        notifyListeners();
        return voucher;
      }
    }
    return null;
  }

  // Scenario Player for pitch demonstrations
  void applyScenarioStep(int step) {
    demoScenarioStep = step;
    
    if (step == 0) {
      // Reset to default
      aisles = List.from(aislesData);
      alerts = List.from(alertsData);
      discounts = List.from(discountsData);
    } else if (step == 1) {
      // 🕓 16:00 — Sushi initial 20% OFF
      for (int i = 0; i < discounts.length; i++) {
        if (discounts[i]['productId'] == 'p2') {
          discounts[i] = {
            ...discounts[i],
            'discountPercent': 20,
            'finalPrice': 79.0,
            'status': 'active',
          };
        }
      }
    } else if (step == 2) {
      // 🕕 18:00 — Heavy Rain detected! Traffic down to 35% -> AI ramps Sushi discount to 40% OFF
      for (int i = 0; i < discounts.length; i++) {
        if (discounts[i]['productId'] == 'p2') {
          discounts[i] = {
            ...discounts[i],
            'discountPercent': 40,
            'finalPrice': 59.0,
            'status': 'active',
            'aiInputs': {
              'weather': '🌧️ Thunderstorm',
              'traffic': '35% (Forecast)',
              'salesVelocity': '6/hr',
              'expiryHours': '1h 00m',
              'payday': false,
            },
          };
        }
      }
      alerts.insert(0, {
        'id': 'al-rain-${DateTime.now().millisecondsSinceEpoch}',
        'type': 'ai',
        'aisleId': 'A3',
        'productId': 'p2',
        'title': 'AI Dynamic Pricing: Sushi 40% OFF',
        'message': 'AI adjusted discount from 20% → 40%',
        'detail': 'Heavy rain detected. Foot traffic dropped to 35%. Accelerated discount to clear 12 units before 19:00.',
        'time': 'Just now',
        'status': 'open',
        'estimatedMinutes': 60,
        'actionRequired': 'Promotional label synced to customer app',
      });
    } else if (step == 3) {
      // 🕖 19:00 — Milk sells out rapidly! Stock = 3, Velocity = 8/hr -> Stockout in ~22 min -> Aisle 4 turns RED
      for (int i = 0; i < aisles.length; i++) {
        if (aisles[i]['id'] == 'A4') {
          aisles[i] = {
            ...aisles[i],
            'status': 'critical',
            'stock': 3,
            'salesVelocity': 8.0,
          };
        }
      }
      alerts.insert(0, {
        'id': 'al-milk-${DateTime.now().millisecondsSinceEpoch}',
        'type': 'critical',
        'aisleId': 'A4',
        'productId': 'p1',
        'title': 'Aisle 4 — Fresh Milk (CRITICAL)',
        'message': 'Fresh Milk critically low (3 units left)',
        'detail': 'Stockout predicted in 22 minutes (Stock 3 ÷ Velocity 8/hr). Staff alert dispatched.',
        'time': 'Just now',
        'status': 'open',
        'estimatedMinutes': 22,
        'actionRequired': 'Urgent restock needed immediately',
      });
    } else if (step == 4) {
      // Staff Alex restocks Aisle 4 -> turns GREEN (40 units)
      for (int i = 0; i < aisles.length; i++) {
        if (aisles[i]['id'] == 'A4') {
          aisles[i] = {
            ...aisles[i],
            'status': 'normal',
            'stock': 40,
          };
        }
      }
      for (int i = 0; i < alerts.length; i++) {
        if (alerts[i]['aisleId'] == 'A4') {
          alerts[i] = {
            ...alerts[i],
            'status': 'resolved',
            'detail': 'Restocked by Staff Alex — 40 units added.',
          };
        }
      }
    }
    notifyListeners();
  }

  // ==========================================
  // FASTAPI BACKEND SYNC METHODS
  // ==========================================

  /// Check whether FastAPI backend at http://127.0.0.1:8000 is reachable
  Future<bool> checkBackendConnection() async {
    isSyncingBackend = true;
    notifyListeners();

    try {
      final healthy = await ApiService.checkHealth();
      isBackendOnline = healthy;
      if (healthy) {
        backendStatusMessage = 'Connected: FastAPI (${ApiService.baseUrl})';
        // Auto fetch initial data
        await syncWithBackend();
      } else {
        backendStatusMessage = 'Offline (Using Mock Data)';
      }
    } catch (e) {
      isBackendOnline = false;
      backendStatusMessage = 'Offline: $e';
    } finally {
      isSyncingBackend = false;
      notifyListeners();
    }
    return isBackendOnline;
  }

  /// Sync all live data from FastAPI Backend
  Future<void> syncWithBackend() async {
    if (!isBackendOnline) return;

    isSyncingBackend = true;
    notifyListeners();

    try {
      // 1. Fetch dashboard summary
      try {
        final summary = await ApiService.getDashboardSummary();
        backendDashboardSummary = summary;
      } catch (e) {
        debugPrint('[AppProvider] Dashboard summary fetch failed: $e');
      }

      // 2. Fetch inventory snapshots & map into active aisles
      try {
        final inv = await ApiService.getInventory();
        backendInventory = inv;
        if (inv.isNotEmpty) {
          aisles = inv.map((item) {
            final pId = item['product_id']?.toString() ?? 'PROD_001';
            final cat = _getCatalogItem(pId);
            final stock = (item['opening_inventory_units'] as num?)?.toInt() ?? 0;
            final days = (item['days_to_expiry'] as num?)?.toInt() ?? 3;

            String status = 'normal';
            if (stock == 0) {
              status = 'critical';
            } else if (days <= 2) {
              status = 'expiring';
            } else if (stock < 5) {
              status = 'low';
            }

            return {
              'id': 'SNAP-${item['snapshot_id']}',
              'productId': pId,
              'name': cat['name'],
              'label': cat['name'],
              'category': cat['category'],
              'icon': cat['emoji'],
              'price': cat['price'],
              'stock': stock,
              'maxStock': 40,
              'daysToExpiry': days,
              'shelfLifeDays': item['standard_shelf_life_days'] ?? 6,
              'status': status,
              'snapshotSource': item['snapshot_source'] ?? 'FastAPI SQLite Database',
              'storeId': item['store_id'] ?? 'STORE_01',
              'snapshotDate': item['snapshot_date'] ?? '2026-10-12',
            };
          }).toList();
        }
      } catch (e) {
        debugPrint('[AppProvider] Inventory fetch failed: $e');
      }

      // 3. Fetch recommendation actions & map into active discounts
      try {
        final recs = await ApiService.getRecommendations();
        backendRecommendations = recs;

        final recDiscounts = <Map<String, dynamic>>[];
        for (final rec in recs) {
          final actions = (rec['actions'] as List?) ?? [];
          final discountAction = actions.firstWhere(
            (a) => a['action'] == 'DISCOUNT',
            orElse: () => null,
          );
          if (discountAction != null) {
            final snapshot = rec['input_payload']?['snapshot'] ?? {};
            final pId = snapshot['product_id']?.toString() ?? 'PROD_001';
            final cat = _getCatalogItem(pId);
            final origPrice = (cat['price'] as num).toDouble();
            final discPercent = (discountAction['discount_percent'] as num?)?.toInt() ?? 20;
            final finalPrice = origPrice * (100 - discPercent) / 100;
            final excess = (discountAction['potential_excess_units'] as num?)?.toDouble() ?? 4.0;
            final stock = (snapshot['opening_inventory_units'] as num?)?.toInt() ?? 10;
            final days = (snapshot['days_to_expiry'] as num?)?.toInt() ?? 2;

            recDiscounts.add({
              'id': 'REC-${rec['recommendation_id']}',
              'recommendationId': rec['recommendation_id'].toString(),
              'productId': pId,
              'productName': cat['name'],
              'name': cat['name'],
              'emoji': cat['emoji'],
              'aisleId': 'Snapshot #${rec['snapshot_id']}',
              'originalPrice': origPrice,
              'discountPercent': discPercent,
              'finalPrice': finalPrice,
              'stock': stock,
              'daysToExpiry': days,
              'expiryFormatted': '$days days remaining (${snapshot['snapshot_date'] ?? '2026-10-12'})',
              'status': rec['approval_status'] == 'APPROVED' ? 'active' : 'proposed',
              'approvalStatus': rec['approval_status'] ?? 'PROPOSED',
              'reasonCode': discountAction['reason_code'] ?? 'NEAR_EXPIRY_EXCESS',
              'aiReasoning': 'AI detected $days days until expiry with $stock opening units. Predicted excess of $excess units. Rule "rules_v1" triggered $discPercent% discount to prevent waste.',
              'isFromBackend': true,
            });
          }
        }
        if (recDiscounts.isNotEmpty) {
          discounts = recDiscounts;
        }
      } catch (e) {
        debugPrint('[AppProvider] Recommendations fetch failed: $e');
      }

      // 4. Fetch customer deals
      try {
        final deals = await ApiService.getDeals();
        backendDeals = deals;
      } catch (e) {
        debugPrint('[AppProvider] Deals fetch failed: $e');
      }

      backendStatusMessage = 'Online (Data Synced from Backend)';
    } catch (e) {
      debugPrint('[AppProvider] Sync error: $e');
    } finally {
      isSyncingBackend = false;
      notifyListeners();
    }
  }

  static const Map<String, Map<String, dynamic>> _productCatalog = {
    'PROD_001': {'name': 'Pasteurized Whole Milk (1L)', 'emoji': '🥛', 'category': 'Dairy', 'price': 45.0},
    'PROD_002': {'name': 'Salmon Nigiri Sushi Set', 'emoji': '🍣', 'category': 'Ready Meal', 'price': 99.0},
    'PROD_003': {'name': 'Caesar Salad with Grilled Chicken', 'emoji': '🥗', 'category': 'Ready Meal', 'price': 120.0},
    'PROD_004': {'name': 'Fresh Squeezed Orange Juice', 'emoji': '🥤', 'category': 'Beverage', 'price': 55.0},
    'PROD_005': {'name': 'Butter Croissant (2-Pack)', 'emoji': '🥐', 'category': 'Bakery', 'price': 65.0},
    'PROD_006': {'name': 'Greek Plain Yogurt 450g', 'emoji': '🥣', 'category': 'Dairy', 'price': 85.0},
    'PROD_007': {'name': 'Mango Sticky Rice Set', 'emoji': '🥭', 'category': 'Dessert', 'price': 70.0},
    'PROD_008': {'name': 'Green Tea Honey Lemon 500ml', 'emoji': '🍵', 'category': 'Beverage', 'price': 30.0},
    'PROD_009': {'name': 'Chicken Teriyaki Bento Box', 'emoji': '🍱', 'category': 'Ready Meal', 'price': 110.0},
    'PROD_010': {'name': 'Organic Silken Tofu 300g', 'emoji': '🧈', 'category': 'Chilled', 'price': 38.0},
    'PROD_011': {'name': 'Fresh Strawberries 250g', 'emoji': '🍓', 'category': 'Fresh Fruit', 'price': 149.0},
    'PROD_012': {'name': 'Artisan Sourdough Loaf', 'emoji': '🍞', 'category': 'Bakery', 'price': 95.0},
  };

  Map<String, dynamic> _getCatalogItem(String productId) {
    if (_productCatalog.containsKey(productId)) {
      return _productCatalog[productId]!;
    }
    return {
      'name': 'Retail Product $productId',
      'emoji': '📦',
      'category': 'Fresh Grocery',
      'price': 65.0,
    };
  }

  /// Send Recommendation Run to backend (e.g. rain-demo or clear-demo)
  Future<bool> triggerBackendScenario(String scenarioId) async {
    if (!isBackendOnline) return false;

    isSyncingBackend = true;
    notifyListeners();

    try {
      await ApiService.createRecommendationRun(scenarioId: scenarioId);
      await syncWithBackend();
      return true;
    } catch (e) {
      debugPrint('[AppProvider] Trigger scenario failed: $e');
      return false;
    } finally {
      isSyncingBackend = false;
      notifyListeners();
    }
  }

  /// Approve recommendation in backend
  Future<bool> approveRecommendation(String recId) async {
    if (isBackendOnline) {
      final ok = await ApiService.updateRecommendationStatus(
        recommendationId: recId,
        status: 'APPROVED',
      );
      if (ok) {
        await syncWithBackend();
        return true;
      }
    }
    // Local fallback
    return true;
  }

  /// Reject recommendation in backend
  Future<bool> rejectRecommendation(String recId) async {
    if (isBackendOnline) {
      final ok = await ApiService.updateRecommendationStatus(
        recommendationId: recId,
        status: 'REJECTED',
      );
      if (ok) {
        await syncWithBackend();
        return true;
      }
    }
    // Local fallback
    return true;
  }
}

