import 'package:flutter/cupertino.dart';
import 'phonepage.dart';

class PhoneSpecsPage extends StatefulWidget {
  final Map<String, dynamic> phone;
  final bool isDark;
  final Function(Map<String, dynamic>)? onAddToCart;

  const PhoneSpecsPage({
    super.key,
    required this.phone,
    required this.isDark,
    this.onAddToCart,
  });

  @override
  State<PhoneSpecsPage> createState() => _PhoneSpecsPageState();
}

class _PhoneSpecsPageState extends State<PhoneSpecsPage> {
  double _fontSize = 15;
  bool _isSaved = false;
  int _currentPage = 1;

  Color get _bg => widget.isDark ? Color(0xFF0A0A0F) : Color(0xFFF0F4FF);
  Color get _card => widget.isDark ? Color(0xFF12121E) : Color(0xFFFFFFFF);
  Color get _text => widget.isDark ? Color(0xFFD0DCFF) : Color(0xFF0D1B4B);
  Color get _subtext => widget.isDark ? Color(0xFF5A6A9A) : Color(0xFF6B7FA8);
  Color get _border => widget.isDark ? Color(0xFF1E2A50) : Color(0xFFD0DCFF);
  Color get _pageText => widget.isDark ? Color(0xFFB0C0E8) : Color(0xFF1A2E5A);

  // Paginated specs content
  List<String> get _pages {
    final phone = widget.phone;
    final name = phone['name'] as String;
    final brand = phone['brand'] as String;

    return [
      // Page 1 — Overview
      phone['excerpt'] as String? ??
          '$name is a flagship smartphone from $brand featuring cutting-edge technology and premium build quality. This device pushes the boundaries of what a smartphone can achieve, combining powerful performance with an exceptional camera system.\n\nDesigned for those who demand the very best, it delivers a seamless experience from the moment you pick it up.',

      // Page 2 — Specs deep dive
      'DISPLAY & PERFORMANCE\n\n${phone['display']} — engineered for vivid colour accuracy and smooth motion across every frame. The ${phone['processor']} delivers industry-leading performance benchmarks, handling AI tasks, gaming, and multitasking with ease.\n\nCAMERA SYSTEM\n\n${phone['camera']} — tuned for exceptional low-light performance and studio-quality portraits. Every shot is processed in real time with computational photography that rivals dedicated cameras.\n\nBATTERY\n\n${phone['battery']} — paired with fast charging technology to keep you powered throughout the day.',

      // Page 3 — Purchase info
      'This is a detailed overview of the ${name} by ${brand}.\n\nAVAILABLE STORAGE\n${(phone['variants'] as List).join(' · ')}\n\nOPERATING SYSTEM\n${phone['os']}\n\nSHOPPING AT PHONE HUB\nAll units are brand new, sealed, and come with the full manufacturer warranty. We offer free shipping on orders above ₱5,000 and nationwide delivery within 3-5 business days.',
    ];
  }

  void _showTextSizeSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: 220,
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: _border)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 20),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: _border,
                      borderRadius: BorderRadius.circular(2)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text('TEXT SIZE',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              color: _subtext)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text('A',
                          style: TextStyle(
                              fontSize: 13,
                              color: _subtext,
                              fontWeight: FontWeight.w500)),
                      Expanded(
                        child: CupertinoSlider(
                          value: _fontSize,
                          min: 12,
                          max: 24,
                          divisions: 6,
                          activeColor: Color(0xFF2563EB),
                          onChanged: (val) {
                            setModalState(() {});
                            setState(() => _fontSize = val);
                          },
                        ),
                      ),
                      Text('A',
                          style: TextStyle(
                              fontSize: 22,
                              color: _subtext,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Font size: ${_fontSize.round()}pt',
                  style: TextStyle(fontSize: 12, color: _subtext),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = widget.phone;
    final pages = _pages;
    final totalPages = pages.length;

    return CupertinoPageScaffold(
      backgroundColor: _bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: _bg.withOpacity(0.95),
        border: Border(bottom: BorderSide(color: _border, width: 0.5)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: _text),
          onPressed: () => Navigator.pop(context),
        ),
        middle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              phone['name'],
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Specs · Page $_currentPage of $totalPages',
              style: TextStyle(fontSize: 10, color: _subtext),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                _isSaved
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                color: _isSaved ? Color(0xFF2563EB) : _subtext,
                size: 20,
              ),
              onPressed: () => setState(() => _isSaved = !_isSaved),
            ),
            CupertinoButton(
              padding: EdgeInsets.only(left: 4),
              child: Icon(CupertinoIcons.textformat_size,
                  color: _subtext, size: 20),
              onPressed: _showTextSizeSheet,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Phone info strip
            Container(
              margin: EdgeInsets.fromLTRB(20, 16, 20, 0),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: widget.isDark
                          ? Color(0xFF1A1A2E)
                          : Color(0xFFEEF2FF),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Image.network(
                          phone['image'],
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => Center(
                              child: Text('📱',
                                  style: TextStyle(fontSize: 24))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phone['name'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: _text),
                          maxLines: 2,
                        ),
                        SizedBox(height: 2),
                        Text(phone['brand'],
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color(0xFF2563EB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'FULL SPECS',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2563EB),
                                letterSpacing: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('₱${phone['price']}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _text)),
                ],
              ),
            ),

            // Content
            Expanded(
              child: PageView.builder(
                itemCount: totalPages,
                onPageChanged: (i) =>
                    setState(() => _currentPage = i + 1),
                itemBuilder: (context, index) {
                  final isLastPage = index == totalPages - 1;
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(28, 28, 28, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0) ...[
                          Text(
                            'OVERVIEW',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 3,
                                color: Color(0xFF2563EB)),
                          ),
                          SizedBox(height: 8),
                          Container(
                              width: 40,
                              height: 2,
                              color: Color(0xFF2563EB)),
                          SizedBox(height: 24),
                        ] else if (index == 1) ...[
                          Text(
                            'SPECIFICATIONS',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 3,
                                color: _subtext),
                          ),
                          SizedBox(height: 20),
                        ] else ...[
                          Text(
                            'PURCHASE INFO',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 3,
                                color: _subtext),
                          ),
                          SizedBox(height: 20),
                        ],

                        Text(
                          pages[index],
                          style: TextStyle(
                            fontSize: _fontSize,
                            color: _pageText,
                            height: 1.85,
                          ),
                        ),

                        if (!isLastPage) ...[
                          SizedBox(height: 40),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    width: 20,
                                    height: 1,
                                    color: _border),
                                SizedBox(width: 8),
                                Text('◆',
                                    style: TextStyle(
                                        fontSize: 8, color: _subtext)),
                                SizedBox(width: 8),
                                Container(
                                    width: 20,
                                    height: 1,
                                    color: _border),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          Center(
                            child: Text(
                              'Swipe to continue →',
                              style: TextStyle(
                                  fontSize: 11, color: _subtext),
                            ),
                          ),
                        ],

                        if (isLastPage) ...[
                          SizedBox(height: 40),
                          Center(
                            child: Column(
                              children: [
                                Container(
                                    width: 60, height: 1, color: _border),
                                SizedBox(height: 24),
                                Text(
                                  'Ready to order?',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: _text),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Starting at ₱${phone['price']}',
                                  style: TextStyle(
                                      fontSize: 13, color: _subtext),
                                ),
                                SizedBox(height: 24),
                                if (widget.onAddToCart != null)
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              PhoneDetailPage(
                                                phone: phone,
                                                onAddToCart:
                                                widget.onAddToCart!,
                                                isDark: widget.isDark,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 14),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Color(0xFF1E40AF),
                                          Color(0xFF2563EB)
                                        ]),
                                        borderRadius:
                                        BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xFF2563EB)
                                                  .withOpacity(0.4),
                                              blurRadius: 12,
                                              offset: Offset(0, 4)),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(CupertinoIcons.cart_fill,
                                              color: Color(0xFFFFFFFF),
                                              size: 16),
                                          SizedBox(width: 8),
                                          Text(
                                            'BUY NOW  ₱${phone['price']}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFFFFFFFF),
                                                letterSpacing: 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page indicator
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border:
                Border(top: BorderSide(color: _border, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPages, (i) {
                  final active = i + 1 == _currentPage;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? Color(0xFF2563EB) : _border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}