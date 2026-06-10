import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'about_page.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ProfilePage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final box = Hive.box("phonehub_db");
  final LocalAuthentication auth = LocalAuthentication();

  // Preferences state
  String _deliveryCity = 'Metro Manila';
  bool _orderUpdates = true;
  bool _dealsAlerts = true;
  String _preferredPayment = 'GCash';

  late bool _biometricsEnabled;

  @override
  void initState() {
    super.initState();
    _biometricsEnabled = box.get("biometrics", defaultValue: false);
  }

  // ── Theme colours ──────────────────────────────────────
  Color get _bg => widget.isDark ? const Color(0xFF0A0A0F) : const Color(0xFFF0F4FF);
  Color get _card => widget.isDark ? const Color(0xFF12121E) : const Color(0xFFFFFFFF);
  Color get _text => widget.isDark ? const Color(0xFFD0DCFF) : const Color(0xFF0D1B4B);
  Color get _subtext => widget.isDark ? const Color(0xFF5A6A9A) : const Color(0xFF6B7FA8);
  Color get _border => widget.isDark ? const Color(0xFF1E2A50) : const Color(0xFFD0DCFF);
  Color get _accent => const Color(0xFF2563EB);

  // ── Hive getters ───────────────────────────────────────
  String get username => box.get("username", defaultValue: "Guest");
  String get email => box.get("email", defaultValue: "guest@phonehub.ph");
  String get fullName => box.get("fullName", defaultValue: "Shopper");

  // ── Biometrics ─────────────────────────────────────────
  void _toggleBiometrics(bool value) async {
    setState(() => _biometricsEnabled = value);
    await box.put("biometrics", value);
    _showAlert(
      value ? 'Biometrics Enabled ✓' : 'Biometrics Disabled',
      value
          ? 'You can now use Face ID or fingerprint to sign in.'
          : 'Biometric sign-in has been disabled.',
    );
  }

  // ── Helpers ────────────────────────────────────────────
  void _showAlert(String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of PHONE HUB?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Sign Out'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Delivery city picker ───────────────────────────────
  void _showCityPicker() {
    final cities = [
      'Metro Manila',
      'Cebu City',
      'Davao City',
      'Quezon City',
      'Makati City',
      'Taguig City',
      'Pasig City',
      'Mandaluyong',
    ];
    int selectedIndex = cities.indexOf(_deliveryCity);
    if (selectedIndex < 0) selectedIndex = 0;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 320,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: _border)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery City',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _text,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: _accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 44,
                  scrollController:
                  FixedExtentScrollController(initialItem: selectedIndex),
                  onSelectedItemChanged: (i) =>
                      setState(() => _deliveryCity = cities[i]),
                  children: cities
                      .map(
                        (c) => Center(
                      child: Text(
                        c,
                        style: TextStyle(fontSize: 17, color: _text),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Payment method picker ──────────────────────────────
  void _showPaymentPicker() {
    final methods = ['GCash', 'Maya', 'Credit Card', 'Bank Transfer', 'Cash on Delivery'];

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 340,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: _border)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Preferred Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _text,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: _accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: methods.map((m) {
                    final isSelected = _preferredPayment == m;
                    final Map<String, String> emojis = {
                      'GCash': '💚',
                      'Maya': '💙',
                      'Credit Card': '💳',
                      'Bank Transfer': '🏦',
                      'Cash on Delivery': '💵',
                    };
                    return GestureDetector(
                      onTap: () => setState(() => _preferredPayment = m),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _accent.withOpacity(0.1)
                              : _bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? _accent : _border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(emojis[m] ?? '💳',
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                m,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: _text,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(CupertinoIcons.checkmark_circle_fill,
                                  color: _accent, size: 20),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Edit profile sheet ─────────────────────────────────
  void _showEditProfile() {
    final nameCtrl =
    TextEditingController(text: box.get("fullName", defaultValue: ""));
    final emailCtrl =
    TextEditingController(text: box.get("email", defaultValue: ""));

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 380,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: _border)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: _border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 20),
                CupertinoTextField(
                  controller: nameCtrl,
                  placeholder: 'Full Name',
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Icon(CupertinoIcons.person, size: 18, color: _subtext),
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                  ),
                  style: TextStyle(color: _text, fontSize: 15),
                  placeholderStyle: TextStyle(color: _subtext, fontSize: 15),
                ),
                const SizedBox(height: 12),
                CupertinoTextField(
                  controller: emailCtrl,
                  placeholder: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Icon(CupertinoIcons.mail, size: 18, color: _subtext),
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                  ),
                  style: TextStyle(color: _text, fontSize: 15),
                  placeholderStyle: TextStyle(color: _subtext, fontSize: 15),
                ),
                const SizedBox(height: 20),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    box.put("fullName", nameCtrl.text.trim());
                    box.put("email", emailCtrl.text.trim());
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFF1E40AF), _accent],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'SAVE CHANGES',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final int ordersCount =
        (box.get("orderHistory") as List?)?.length ?? 0;
    final int cartCount =
        (box.get("cartItems") as List?)?.length ?? 0;
    final String joined = () {
      final raw = box.get("accountCreated");
      if (raw == null) return 'Today';
      final dt = DateTime.tryParse(raw.toString());
      if (dt == null) return 'Today';
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.year}';
    }();

    return CupertinoPageScaffold(
      backgroundColor: _bg,
      child: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D1B4B), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar row
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text('📱', style: TextStyle(fontSize: 30)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName.isEmpty ? username : fullName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '@$username',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _showEditProfile,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('📦', 'Orders', '$ordersCount'),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _buildStat('🛒', 'In Cart', '$cartCount'),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _buildStat('📅', 'Joined', joined),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Sections ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── APPEARANCE ──────────────────────────
                  _buildSectionTitle('APPEARANCE'),
                  const SizedBox(height: 8),
                  _buildGroup([
                    _buildTile(
                      widget.isDark
                          ? CupertinoIcons.moon_fill
                          : CupertinoIcons.sun_max_fill,
                      'Dark Mode',
                      widget.isDark
                          ? const Color(0xFF5E5CE6)
                          : const Color(0xFFFF9500),
                      trailing: CupertinoSwitch(
                        value: widget.isDark,
                        onChanged: (_) => widget.onToggleTheme(),
                        activeColor: _accent,
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── SECURITY ────────────────────────────
                  _buildSectionTitle('SECURITY'),
                  const SizedBox(height: 8),
                  _buildGroup([
                    _buildTile(
                      CupertinoIcons.lock_shield_fill,
                      'Biometric Sign-In',
                      const Color(0xFF34C759),
                      trailing: CupertinoSwitch(
                        value: _biometricsEnabled,
                        onChanged: _toggleBiometrics,
                        activeColor: _accent,
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── NOTIFICATIONS ────────────────────────
                  _buildSectionTitle('NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  _buildGroup([
                    _buildTile(
                      CupertinoIcons.cube_box_fill,
                      'Order Updates',
                      const Color(0xFF007AFF),
                      trailing: CupertinoSwitch(
                        value: _orderUpdates,
                        onChanged: (val) =>
                            setState(() => _orderUpdates = val),
                        activeColor: _accent,
                      ),
                    ),
                    _buildDivider(),
                    _buildTile(
                      CupertinoIcons.tag_fill,
                      'Deals & Promos',
                      const Color(0xFFFF9500),
                      trailing: CupertinoSwitch(
                        value: _dealsAlerts,
                        onChanged: (val) =>
                            setState(() => _dealsAlerts = val),
                        activeColor: _accent,
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── SHOPPING ────────────────────────────
                  _buildSectionTitle('SHOPPING PREFERENCES'),
                  const SizedBox(height: 8),
                  _buildGroup([
                    _buildTapTile(
                      CupertinoIcons.location_fill,
                      'Delivery City',
                      const Color(0xFF34C759),
                      _showCityPicker,
                      trailingLabel: _deliveryCity,
                    ),
                    _buildDivider(),
                    _buildTapTile(
                      CupertinoIcons.creditcard_fill,
                      'Preferred Payment',
                      const Color(0xFF32ADE6),
                      _showPaymentPicker,
                      trailingLabel: _preferredPayment,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── STORE ───────────────────────────────
                  _buildSectionTitle('STORE'),
                  const SizedBox(height: 8),
                  _buildGroup([
                    _buildTapTile(
                      CupertinoIcons.info_circle_fill,
                      'About PHONE HUB',
                      const Color(0xFF007AFF),
                          () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                AboutPage(isDark: widget.isDark),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildTapTile(
                      CupertinoIcons.shield_fill,
                      'Warranty & Returns',
                      const Color(0xFF5E5CE6),
                          () => _showAlert(
                        'Warranty & Returns',
                        '• 1-year manufacturer warranty on all phones\n• 30-day return policy on unopened items\n• Contact support for defective units',
                      ),
                    ),
                    _buildDivider(),
                    _buildTapTile(
                      CupertinoIcons.lock_fill,
                      'Privacy Policy',
                      const Color(0xFF636366),
                          () => _showAlert(
                        'Privacy Policy',
                        'PHONE HUB respects your privacy. We do not sell or share your personal data with third parties without your consent.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── SUPPORT ─────────────────────────────
                  _buildSectionTitle('SUPPORT'),
                  const SizedBox(height: 8),
                  _buildGroup([
                    _buildTapTile(
                      CupertinoIcons.chat_bubble_fill,
                      'Help & Support',
                      const Color(0xFF32ADE6),
                          () => _showAlert(
                        'Help & Support',
                        'hello@phonehub.ph\n+63 917 123 4567\n\nMonday–Saturday, 9AM–6PM',
                      ),
                    ),
                    _buildDivider(),
                    _buildTapTile(
                      CupertinoIcons.star_fill,
                      'Rate PHONE HUB',
                      const Color(0xFFFFAA00),
                          () => _showAlert(
                        'Thank You!',
                        'Your feedback helps us serve shoppers better. Leave us a review on the App Store!',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── ACCOUNT ─────────────────────────────
                  _buildSectionTitle('ACCOUNT'),
                  const SizedBox(height: 8),
                  _buildGroup([
                    _buildTapTile(
                      CupertinoIcons.square_arrow_right,
                      'Sign Out',
                      const Color(0xFFFF3B30),
                      _logout,
                    ),
                  ]),

                  const SizedBox(height: 28),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '📱 PHONE HUB',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _subtext,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'v1.0.0 · Your Premium Phone Store',
                          style: TextStyle(fontSize: 11, color: _border),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper widgets ──────────────────────────────────────
  Widget _buildStat(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFFFFFFFF),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.6),
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: _subtext,
      ),
    );
  }

  Widget _buildGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() => Container(
    margin: const EdgeInsets.only(left: 56),
    height: 1,
    color: _border,
  );

  Widget _buildTile(
      IconData icon,
      String title,
      Color color, {
        required Widget trailing,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFFFFFFFF)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 15, color: _text),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildTapTile(
      IconData icon,
      String title,
      Color color,
      VoidCallback onTap, {
        String? trailingLabel,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: const Color(0x00000000),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: const Color(0xFFFFFFFF)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15, color: _text),
              ),
            ),
            if (trailingLabel != null) ...[
              Text(
                trailingLabel,
                style: TextStyle(fontSize: 13, color: _subtext),
              ),
              const SizedBox(width: 4),
            ],
            Icon(CupertinoIcons.chevron_forward, color: _border, size: 16),
          ],
        ),
      ),
    );
  }
}

// Convenience reference so Colors.white works without material import
class Colors {
  static const Color white = Color(0xFFFFFFFF);
}