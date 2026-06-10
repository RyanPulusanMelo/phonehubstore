import 'package:flutter/cupertino.dart';

class AboutPage extends StatelessWidget {
  final bool isDark;

  const AboutPage({
    super.key,
    required this.isDark,
  });

  // ── Theme colours ──────────────────────────────────────
  Color get _bg => isDark ? const Color(0xFF0A0A0F) : const Color(0xFFF0F4FF);
  Color get _card => isDark ? const Color(0xFF12121E) : const Color(0xFFFFFFFF);
  Color get _text => isDark ? const Color(0xFFD0DCFF) : const Color(0xFF0D1B4B);
  Color get _subtext => isDark ? const Color(0xFF5A6A9A) : const Color(0xFF6B7FA8);
  Color get _border => isDark ? const Color(0xFF1E2A50) : const Color(0xFFD0DCFF);
  Color get _accent => const Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: _bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: isDark
            ? const Color(0xFF0A0A0F).withOpacity(0.95)
            : const Color(0xFFF0F4FF).withOpacity(0.95),
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.back,
            color: isDark ? const Color(0xFFD0DCFF) : const Color(0xFF0D1B4B),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text(
          'ABOUT',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            fontSize: 14,
            color: isDark ? const Color(0xFFD0DCFF) : const Color(0xFF0D1B4B),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),

            // ── App icon ─────────────────────────────────
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D1B4B), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('📱', style: TextStyle(fontSize: 42)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                'PHONE HUB',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                  color: _text,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Center(
              child: Text(
                'Premium Smartphone Store & Tech Collection',
                style: TextStyle(
                  fontSize: 13,
                  color: _subtext,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── Our Story ────────────────────────────────
            _buildSection(
              'OUR STORY',
              'PHONE HUB was built on a single idea: everyone deserves access to the best smartphones on the market. We curate the finest devices — from flagship iPhones to the latest Android powerhouses — and bring them straight to your door across the Philippines.',
            ),

            const SizedBox(height: 16),

            // ── Our Mission ──────────────────────────────
            _buildSection(
              'OUR MISSION',
              'We are committed to making premium smartphones accessible to every Filipino. With an unbeatable selection, transparent pricing, and seamless nationwide delivery, PHONE HUB is the country\'s most trusted mobile store.',
            ),

            const SizedBox(height: 16),

            // ── What We Offer ────────────────────────────
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('WHAT WE OFFER'),
                  const SizedBox(height: 16),
                  _buildFeature('📱', 'Curated Selection of 500+ Smartphone Models'),
                  _buildFeature('🔍', 'Smart Device Discovery & Comparisons'),
                  _buildFeature('🚚', 'Fast & Secure Nationwide Delivery'),
                  _buildFeature('📦', 'Real-time Order Tracking'),
                  _buildFeature('💳', 'Secure Checkout via GCash, Maya & Cards'),
                  _buildFeature('🆓', 'Free Shipping on Orders Over ₱999'),
                  _buildFeature('↩️', '30-Day Return Policy'),
                  _buildFeature('🛡️', '1-Year Manufacturer Warranty'),
                  _buildFeature('🎧', '24/7 Customer Support'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Brands We Carry ──────────────────────────
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('BRANDS WE CARRY'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      'Apple', 'Samsung', 'Google', 'Xiaomi',
                      'OPPO', 'Vivo', 'OnePlus', 'Realme',
                    ].map((brand) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _accent.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        brand,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _accent,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Contact ──────────────────────────────────
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('GET IN TOUCH'),
                  const SizedBox(height: 16),
                  _buildContactInfo(
                    CupertinoIcons.mail_solid,
                    'Email',
                    'hello@phonehub.ph',
                    const Color(0xFF007AFF),
                  ),
                  const SizedBox(height: 12),
                  _buildContactInfo(
                    CupertinoIcons.phone_fill,
                    'Phone',
                    '+63 917 123 4567',
                    const Color(0xFF34C759),
                  ),
                  const SizedBox(height: 12),
                  _buildContactInfo(
                    CupertinoIcons.location_fill,
                    'Location',
                    'BGC, Taguig City, Metro Manila, PH',
                    const Color(0xFFFF9500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Social ───────────────────────────────────
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('FOLLOW US'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton('📘', 'Facebook'),
                      _buildSocialButton('📷', 'Instagram'),
                      _buildSocialButton('🐦', 'Twitter'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                '© 2026 PHONE HUB. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: _subtext,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Center(
              child: Text(
                'Made with ❤️ for Filipino shoppers',
                style: TextStyle(
                  fontSize: 12,
                  color: _subtext,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Helper widgets ──────────────────────────────────────

  Widget _buildSection(String label, String text) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel(label),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              height: 1.7,
              color: _subtext,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF000000).withOpacity(0.4)
                : const Color(0xFF2563EB).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        color: Color(0xFF2563EB),
      ),
    );
  }

  Widget _buildFeature(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: _text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(
      IconData icon,
      String label,
      String value,
      Color color,
      ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: _subtext,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(String emoji, String platform) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F3A) : const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          platform,
          style: TextStyle(
            fontSize: 12,
            color: _subtext,
          ),
        ),
      ],
    );
  }
}