import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_provider.dart';
import '../data/mock_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 'signin', 'register_select', 'register_employee', 'register_customer'
  String _authScreen = 'signin';

  // Sign In state
  String _selectedRole = 'manager';

  // Employee Form Controllers
  final _empNameCtrl = TextEditingController();
  final _empEmailCtrl = TextEditingController();
  final _empCodeCtrl = TextEditingController(text: 'FF-MGR-001');
  final _empPassCtrl = TextEditingController();
  final _empConfirmPassCtrl = TextEditingController();
  String _empRole = 'manager'; // 'manager' or 'staff'
  String _empBranch = nearbyStoresData.first['name'];

  // Customer Form Controllers
  final _custNameCtrl = TextEditingController();
  final _custEmailCtrl = TextEditingController();
  final _custPhoneCtrl = TextEditingController();
  final _custPassCtrl = TextEditingController();
  final _custConfirmPassCtrl = TextEditingController();
  bool _agreeTerms = true;

  String? _errorMessage;

  @override
  void dispose() {
    _empNameCtrl.dispose();
    _empEmailCtrl.dispose();
    _empCodeCtrl.dispose();
    _empPassCtrl.dispose();
    _empConfirmPassCtrl.dispose();

    _custNameCtrl.dispose();
    _custEmailCtrl.dispose();
    _custPhoneCtrl.dispose();
    _custPassCtrl.dispose();
    _custConfirmPassCtrl.dispose();
    super.dispose();
  }

  void _handleEmployeeRegister() {
    final name = _empNameCtrl.text.trim();
    final email = _empEmailCtrl.text.trim();
    final code = _empCodeCtrl.text.trim();
    final pass = _empPassCtrl.text;
    final confirm = _empConfirmPassCtrl.text;

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Please enter your full name (กรุณากรอกชื่อ-นามสกุล)');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid work email (กรุณากรอกอีเมลที่ถูกต้อง)');
      return;
    }
    if (code.isEmpty) {
      setState(() => _errorMessage = _empRole == 'manager'
          ? 'Manager Invitation Code required (ต้องใช้รหัสเชิญผู้จัดการ เช่น FF-MGR-001)'
          : 'Staff Employee Code required (ต้องใช้รหัสพนักงาน เช่น FF-STAFF-001)');
      return;
    }
    if (pass.length < 4) {
      setState(() => _errorMessage = 'Password must be at least 4 characters');
      return;
    }
    if (pass != confirm) {
      setState(() => _errorMessage = 'Passwords do not match (รหัสผ่านไม่ตรงกัน)');
      return;
    }

    final result = context.read<AppProvider>().registerEmployee(
      name: name,
      email: email,
      password: pass,
      role: _empRole,
      branch: _empBranch,
      code: code,
    );

    if (result['success'] == true) {
      setState(() => _errorMessage = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Welcome to FreshFlow, $name! Account created as $_empRole.'),
          backgroundColor: const Color(0xFF16A34A),
          duration: const Duration(seconds: 3),
        ),
      );
      context.go('/$_empRole');
    } else {
      setState(() => _errorMessage = result['message'] as String?);
    }
  }

  void _handleCustomerRegister() {
    final name = _custNameCtrl.text.trim();
    final email = _custEmailCtrl.text.trim();
    final phone = _custPhoneCtrl.text.trim();
    final pass = _custPassCtrl.text;
    final confirm = _custConfirmPassCtrl.text;

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Please enter your full name (กรุณากรอกชื่อ-นามสกุล)');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email (กรุณากรอกอีเมลที่ถูกต้อง)');
      return;
    }
    if (phone.isEmpty) {
      setState(() => _errorMessage = 'Please enter your phone number (กรุณากรอกเบอร์โทรศัพท์)');
      return;
    }
    if (pass.length < 4) {
      setState(() => _errorMessage = 'Password must be at least 4 characters');
      return;
    }
    if (pass != confirm) {
      setState(() => _errorMessage = 'Passwords do not match (รหัสผ่านไม่ตรงกัน)');
      return;
    }
    if (!_agreeTerms) {
      setState(() => _errorMessage = 'Please agree to Terms & Privacy Policy');
      return;
    }

    final result = context.read<AppProvider>().registerCustomer(
      name: name,
      email: email,
      phone: phone,
      password: pass,
    );

    if (result['success'] == true) {
      setState(() => _errorMessage = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Welcome to FreshFlow, $name! Start saving food and grab flash deals.'),
          backgroundColor: const Color(0xFF16A34A),
          duration: const Duration(seconds: 3),
        ),
      );
      context.go('/customer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            bottom: -100,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.18),
                    blurRadius: 160,
                    spreadRadius: 60,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      Center(
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: const Color(0xFF16A34A),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF16A34A).withValues(alpha: 0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.grass, color: Colors.white, size: 38),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        'FreshFlow',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Smart Retail Platform · AI Food Waste & Restock Intelligence',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Card Container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF334155), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _buildCurrentAuthView(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Footer
                      Text(
                        'FreshFlow Smart Retail Platform · National Pitch Demo Ready',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentAuthView() {
    switch (_authScreen) {
      case 'register_select':
        return _buildRegisterSelectTypeView();
      case 'register_employee':
        return _buildRegisterEmployeeView();
      case 'register_customer':
        return _buildRegisterCustomerView();
      case 'signin':
      default:
        return _buildSignInView();
    }
  }

  // ==========================================
  // 1. SIGN IN VIEW (Demo Accounts & Fast Login)
  // ==========================================
  Widget _buildSignInView() {
    return Column(
      key: const ValueKey('signin_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sign In',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            InkWell(
              onTap: () => setState(() {
                _authScreen = 'register_select';
                _errorMessage = null;
              }),
              child: Text(
                'Register Now →',
                style: GoogleFonts.inter(
                  color: const Color(0xFF16A34A),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Select demo account or enter credentials',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 20),

        // 1-Click Demo Selectors
        _buildRoleSelector(
          id: 'manager',
          title: 'Store Manager (ผู้จัดการสาขา)',
          subtitle: 'Dashboard, 2D floorplan, AI pricing, restock center',
          emoji: '👨‍💼',
          selectedId: _selectedRole,
          onSelect: (id) => setState(() => _selectedRole = id),
        ),
        const SizedBox(height: 10),
        _buildRoleSelector(
          id: 'staff',
          title: 'Floor Staff (พนักงานร้าน)',
          subtitle: 'Mobile to-do tasks, instant restock triggers',
          emoji: '🧑‍🔧',
          selectedId: _selectedRole,
          onSelect: (id) => setState(() => _selectedRole = id),
        ),
        const SizedBox(height: 10),
        _buildRoleSelector(
          id: 'customer',
          title: 'Shopper / Customer (ลูกค้า)',
          subtitle: 'Flash clearance deals feed & claimable QR vouchers',
          emoji: '🛒',
          selectedId: _selectedRole,
          onSelect: (id) => setState(() => _selectedRole = id),
        ),

        const SizedBox(height: 20),

        // Credentials Preview
        Text(
          'DEMO CREDENTIALS',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        _buildStaticTextField('$_selectedRole@freshflow.ai'),
        const SizedBox(height: 8),
        _buildStaticTextField('••••••••••••'),

        const SizedBox(height: 24),

        // Continue Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              context.read<AppProvider>().setRole(_selectedRole);
              context.go('/$_selectedRole');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Enter as ${_capitalize(_selectedRole)} →',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
        Center(
          child: InkWell(
            onTap: () => setState(() {
              _authScreen = 'register_select';
              _errorMessage = null;
            }),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                children: const [
                  TextSpan(text: "Don't have an account? "),
                  TextSpan(text: 'Create Account', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. REGISTER SELECT TYPE (Employee vs Customer)
  // ==========================================
  Widget _buildRegisterSelectTypeView() {
    return Column(
      key: const ValueKey('register_select_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'What are you?',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            InkWell(
              onTap: () => setState(() => _authScreen = 'signin'),
              child: Text(
                'Sign In',
                style: GoogleFonts.inter(
                  color: const Color(0xFF16A34A),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Choose your account type to register',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 24),

        // Option 1: Employee (Manager / Staff)
        InkWell(
          onTap: () => setState(() {
            _authScreen = 'register_employee';
            _errorMessage = null;
          }),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text('👨‍💼', style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Employee (พนักงานร้าน)',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, color: Color(0xFF64748B), size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Manager / Floor Staff · Invitation or Staff Code required',
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
          ),
        ),

        const SizedBox(height: 14),

        // Option 2: Customer (Shopper)
        InkWell(
          onTap: () => setState(() {
            _authScreen = 'register_customer';
            _errorMessage = null;
          }),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🛒', style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Customer (ลูกค้า)',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, color: Color(0xFF64748B), size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Shop & Save Food · Flash Clearance Deals near you',
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
          ),
        ),

        const SizedBox(height: 24),
        Center(
          child: InkWell(
            onTap: () => setState(() => _authScreen = 'signin'),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                children: const [
                  TextSpan(text: 'Already have an account? '),
                  TextSpan(text: 'Sign In', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 3. REGISTER EMPLOYEE (Manager & Staff)
  // ==========================================
  Widget _buildRegisterEmployeeView() {
    final isManager = _empRole == 'manager';

    return Column(
      key: const ValueKey('register_employee_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => setState(() => _authScreen = 'register_select'),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.arrow_back, color: Color(0xFF94A3B8), size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Employee Account',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'For FreshFlow store employees',
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
        const SizedBox(height: 20),

        // Role Segment Toggle (Manager vs Staff)
        Text(
          'I AM REGISTERING AS (ตำแหน่ง)',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() {
                  _empRole = 'manager';
                  _empCodeCtrl.text = 'FF-MGR-001';
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isManager ? const Color(0xFF2563EB).withValues(alpha: 0.2) : const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isManager ? const Color(0xFF2563EB) : const Color(0xFF334155),
                      width: isManager ? 1.5 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '👨‍💼 Manager',
                    style: GoogleFonts.inter(
                      color: isManager ? Colors.white : const Color(0xFF94A3B8),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () => setState(() {
                  _empRole = 'staff';
                  _empCodeCtrl.text = 'FF-STAFF-001';
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !isManager ? const Color(0xFF16A34A).withValues(alpha: 0.2) : const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: !isManager ? const Color(0xFF16A34A) : const Color(0xFF334155),
                      width: !isManager ? 1.5 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '👤 Staff',
                    style: GoogleFonts.inter(
                      color: !isManager ? Colors.white : const Color(0xFF94A3B8),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (_errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.inter(color: const Color(0xFFFCA5A5), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Full Name
        _buildInputLabel('FULL NAME (ชื่อ-นามสกุล)'),
        const SizedBox(height: 6),
        _buildEditableTextField(_empNameCtrl, isManager ? 'e.g. Somchai Jaidee' : 'e.g. Alex Rivera', Icons.person_outline),
        const SizedBox(height: 12),

        // Email
        _buildInputLabel('WORK EMAIL (อีเมลทำงาน)'),
        const SizedBox(height: 6),
        _buildEditableTextField(_empEmailCtrl, isManager ? 'manager@freshflow.ai' : 'staff@freshflow.ai', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 12),

        // Store Branch Dropdown
        _buildInputLabel('STORE BRANCH (สาขาที่สังกัด)'),
        const SizedBox(height: 6),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _empBranch,
              dropdownColor: const Color(0xFF1E293B),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              onChanged: (val) {
                if (val != null) setState(() => _empBranch = val);
              },
              items: nearbyStoresData.map((store) {
                return DropdownMenuItem<String>(
                  value: store['name'] as String,
                  child: Text(store['name'] as String, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Security Code (Manager Invitation Code vs Staff Code)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildInputLabel(isManager ? 'MANAGER INVITATION CODE (รหัสเชิญ)' : 'EMPLOYEE ID / STAFF CODE (รหัสพนักงาน)'),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => setState(() => _empCodeCtrl.text = isManager ? 'FF-MGR-001' : 'FF-STAFF-001'),
              child: Text(
                'Demo: ${isManager ? 'FF-MGR-001' : 'FF-STAFF-001'}',
                style: GoogleFonts.robotoMono(color: const Color(0xFF86EFAC), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _buildEditableTextField(_empCodeCtrl, isManager ? 'FF-MGR-001' : 'FF-STAFF-001', Icons.vpn_key_outlined),
        const SizedBox(height: 12),

        // Password & Confirm
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('PASSWORD'),
                  const SizedBox(height: 6),
                  _buildEditableTextField(_empPassCtrl, '••••••••', Icons.lock_outline, obscureText: true),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('CONFIRM'),
                  const SizedBox(height: 6),
                  _buildEditableTextField(_empConfirmPassCtrl, '••••••••', Icons.lock_outline, obscureText: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _handleEmployeeRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: isManager ? const Color(0xFF2563EB) : const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Create Employee Account (สร้างบัญชี) →',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. REGISTER CUSTOMER (Shop & Save Food)
  // ==========================================
  Widget _buildRegisterCustomerView() {
    return Column(
      key: const ValueKey('register_customer_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => setState(() => _authScreen = 'register_select'),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.arrow_back, color: Color(0xFF94A3B8), size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Customer Account',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Join FreshFlow & discover smart savings',
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
        const SizedBox(height: 20),

        if (_errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.inter(color: const Color(0xFFFCA5A5), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Full Name
        _buildInputLabel('FULL NAME (ชื่อ-นามสกุล)'),
        const SizedBox(height: 6),
        _buildEditableTextField(_custNameCtrl, 'e.g. Tanawat Boonme', Icons.person_outline),
        const SizedBox(height: 12),

        // Email
        _buildInputLabel('EMAIL ADDRESS (อีเมล)'),
        const SizedBox(height: 6),
        _buildEditableTextField(_custEmailCtrl, 'tanawat@email.com', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 12),

        // Phone Number
        _buildInputLabel('PHONE NUMBER (เบอร์โทรศัพท์)'),
        const SizedBox(height: 6),
        _buildEditableTextField(_custPhoneCtrl, '081-234-5678', Icons.phone_outlined, keyboardType: TextInputType.phone),
        const SizedBox(height: 12),

        // Password & Confirm
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('PASSWORD'),
                  const SizedBox(height: 6),
                  _buildEditableTextField(_custPassCtrl, '••••••••', Icons.lock_outline, obscureText: true),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('CONFIRM'),
                  const SizedBox(height: 6),
                  _buildEditableTextField(_custConfirmPassCtrl, '••••••••', Icons.lock_outline, obscureText: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Terms & Policy Checkbox
        Row(
          children: [
            Checkbox(
              value: _agreeTerms,
              activeColor: const Color(0xFF16A34A),
              onChanged: (val) => setState(() => _agreeTerms = val ?? false),
            ),
            Expanded(
              child: Text(
                'I agree to the Terms & Privacy Policy',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFCBD5E1)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _handleCustomerRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Create Customer Account →',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildInputLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF94A3B8),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildEditableTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }

  Widget _buildRoleSelector({
    required String id,
    required String title,
    required String subtitle,
    required String emoji,
    required String selectedId,
    required Function(String) onSelect,
  }) {
    final isSelected = selectedId == id;

    return GestureDetector(
      onTap: () => onSelect(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF16A34A).withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF16A34A) : const Color(0xFF334155),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF16A34A) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticTextField(String hint) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        hint,
        style: GoogleFonts.robotoMono(
          color: const Color(0xFF94A3B8),
          fontSize: 13,
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
