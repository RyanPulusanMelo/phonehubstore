import 'package:flutter/cupertino.dart';

class PhoneDetailPage extends StatefulWidget {
  final Map<String, dynamic> phone;
  final Function(Map<String, dynamic>) onAddToCart;
  final bool isDark;

  const PhoneDetailPage({
    super.key,
    required this.phone,
    required this.onAddToCart,
    required this.isDark,
  });

  @override
  State<PhoneDetailPage> createState() => _PhoneDetailPageState();
}

class _PhoneDetailPageState extends State<PhoneDetailPage> {
  Color get _bg => widget.isDark ? Color(0xFF0A0A0F) : Color(0xFFF0F4FF);
  Color get _card => widget.isDark ? Color(0xFF12121E) : Color(0xFFFFFFFF);
  Color get _text => widget.isDark ? Color(0xFFD0DCFF) : Color(0xFF0D1B4B);
  Color get _subtext => widget.isDark ? Color(0xFF5A6A9A) : Color(0xFF6B7FA8);
  Color get _border => widget.isDark ? Color(0xFF1E2A50) : Color(0xFFD0DCFF);

  void _showVariantSelector() {
    String? selectedVariant;

    int getVariantPrice(String? variant) {
      if (variant == null) return widget.phone['price'] as int;
      final prices = widget.phone['variantPrices'];
      if (prices != null && prices[variant] != null) return prices[variant] as int;
      return widget.phone['price'] as int;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final displayedPrice = getVariantPrice(selectedVariant);

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Phone info header
                            Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: _border),
                                    color: widget.isDark ? Color(0xFF1A1A2E) : Color(0xFFEEF2FF),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Image.asset(
                                        widget.phone['image'],
                                        fit: BoxFit.contain,
                                        errorBuilder: (c, e, s) => Center(
                                          child: Text('📱', style: TextStyle(fontSize: 32)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.phone['name'],
                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _text),
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 4),
                                      Text(widget.phone['brand'], style: TextStyle(fontSize: 13, color: _subtext)),
                                      SizedBox(height: 8),
                                      // Price updates live as variant is selected
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\u20b1$displayedPrice',
                                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                                          ),
                                          if (selectedVariant != null) ...[
                                            SizedBox(width: 6),
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 3),
                                              child: Text(
                                                selectedVariant!,
                                                style: TextStyle(fontSize: 12, color: _subtext, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 28),
                            Text(
                              'SELECT STORAGE',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2, color: _subtext),
                            ),
                            SizedBox(height: 14),
                            ...widget.phone['variants'].map<Widget>((variant) {
                              final isSelected = selectedVariant == variant;
                              final variantCost = getVariantPrice(variant as String);
                              final basePrice = widget.phone['price'] as int;
                              final priceDiff = variantCost - basePrice;
                              return GestureDetector(
                                onTap: () => setModalState(() => selectedVariant = variant),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Color(0xFF2563EB).withOpacity(0.1)
                                        : widget.isDark ? Color(0xFF0A0A0F) : Color(0xFFF0F4FF),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected ? Color(0xFF2563EB) : _border,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: isSelected ? Color(0xFF2563EB).withOpacity(0.15) : _border.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(child: Text('💾', style: TextStyle(fontSize: 18))),
                                      ),
                                      SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              variant,
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                                                  color: isSelected ? Color(0xFF2563EB) : _text),
                                            ),
                                            Text('Internal storage', style: TextStyle(fontSize: 12, color: _subtext)),
                                          ],
                                        ),
                                      ),
                                      // Per-variant price column
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\u20b1$variantCost',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: isSelected ? Color(0xFF2563EB) : _text,
                                            ),
                                          ),
                                          Text(
                                            priceDiff == 0 ? 'Base' : '+\u20b1$priceDiff',
                                            style: TextStyle(fontSize: 11, color: _subtext),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8),
                                      if (isSelected)
                                        Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF2563EB), size: 20),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _card,
                        border: Border(top: BorderSide(color: _border)),
                      ),
                      child: SafeArea(
                        top: false,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (selectedVariant == null) {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: Text('Select Storage'),
                                  content: Text('Please choose a storage variant to continue.'),
                                  actions: [
                                    CupertinoDialogAction(child: Text('OK'), onPressed: () => Navigator.pop(context)),
                                  ],
                                ),
                              );
                              return;
                            }
                            final cartPrice = getVariantPrice(selectedVariant);
                            widget.onAddToCart({
                              ...widget.phone,
                              'price': cartPrice,
                              'selectedVariant': selectedVariant,
                              'selectedColor': selectedVariant,
                            });
                            Navigator.pop(modalContext);
                            Navigator.pop(this.context);
                            showCupertinoDialog(
                              context: this.context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Text('Added to Cart \ud83d\udcf1'),
                                content: Text('${widget.phone['name']} ($selectedVariant) — \u20b1$cartPrice added to your cart!'),
                                actions: [
                                  CupertinoDialogAction(child: Text('Keep Browsing'), onPressed: () => Navigator.pop(context)),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xFF1E40AF), Color(0xFF2563EB)]),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [BoxShadow(color: Color(0xFF2563EB).withOpacity(0.4), blurRadius: 12, offset: Offset(0, 4))],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.cart_fill, color: Color(0xFFFFFFFF), size: 18),
                                  SizedBox(width: 10),
                                  Text(
                                    selectedVariant == null ? 'ADD TO CART' : 'ADD TO CART  \u20b1$displayedPrice',
                                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = widget.phone;

    return CupertinoPageScaffold(
      backgroundColor: _bg,
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Phone image header
              SliverToBoxAdapter(
                child: Container(
                  height: 360,
                  color: widget.isDark
                      ? Color(0xFF1A1A2E)
                      : Color(0xFFEEF2FF),
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40, bottom: 20),
                          child: Container(
                            width: 220,
                            child: Image.asset(
                              phone['image'],
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => Center(
                                child: Text('📱',
                                    style: TextStyle(fontSize: 100)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.pop(context),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: widget.isDark
                                    ? Color(0xFF12121E).withOpacity(0.9)
                                    : Color(0xFFFFFFFF).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _border),
                              ),
                              child: Icon(CupertinoIcons.back,
                                  color: _text, size: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Spec tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (phone['specs'] as List)
                              .map<Widget>((spec) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF2563EB)
                                  .withOpacity(0.12),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              spec,
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ))
                              .toList(),
                        ),
                        SizedBox(height: 14),

                        Text(
                          phone['name'],
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: _text,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 6),

                        Text(
                          phone['brand'],
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),

                        Row(
                          children: [
                            ...List.generate(
                                5,
                                    (i) => Icon(
                                  i < (phone['rating'] as double).floor()
                                      ? CupertinoIcons.star_fill
                                      : CupertinoIcons.star,
                                  size: 16,
                                  color: Color(0xFFFFAA00),
                                )),
                            SizedBox(width: 8),
                            Text(
                              '${phone['rating']} · ${phone['reviews'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} reviews',
                              style: TextStyle(
                                  fontSize: 13, color: _subtext),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),

                        Text(
                          '₱${phone['price']}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: _text,
                          ),
                        ),

                        SizedBox(height: 20),

                        Container(height: 1, color: _border),
                        SizedBox(height: 20),

                        Text(
                          'ABOUT THIS PHONE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: _subtext,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          phone['description'],
                          style: TextStyle(
                            fontSize: 15,
                            color: widget.isDark
                                ? Color(0xFFB0C0E8)
                                : Color(0xFF2A3A6B),
                            height: 1.7,
                          ),
                        ),

                        SizedBox(height: 24),

                        // Specs grid
                        Text(
                          'FULL SPECIFICATIONS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: _subtext,
                          ),
                        ),
                        SizedBox(height: 12),

                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _border),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                  'Display', phone['display']),
                              _buildDivider(),
                              _buildDetailRow(
                                  'Processor', phone['processor']),
                              _buildDivider(),
                              _buildDetailRow(
                                  'Camera', phone['camera']),
                              _buildDivider(),
                              _buildDetailRow(
                                  'Battery', phone['battery']),
                              _buildDivider(),
                              _buildDetailRow('OS', phone['os']),
                              _buildDivider(),
                              _buildDetailRow(
                                  'Storage', phone['storage']),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Available storage
                        Text(
                          'AVAILABLE STORAGE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: _subtext,
                          ),
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                          (phone['variants'] as List).map<Widget>((v) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _card,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('💾',
                                      style: TextStyle(fontSize: 14)),
                                  SizedBox(width: 6),
                                  Text(
                                    v,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _text,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Fixed Add to Cart Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _card.withOpacity(0.97),
                border: Border(
                    top: BorderSide(color: _border, width: 1)),
              ),
              child: SafeArea(
                top: false,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _showVariantSelector,
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF1E40AF),
                          Color(0xFF2563EB)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2563EB).withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.cart_fill,
                              color: Color(0xFFFFFFFF), size: 18),
                          SizedBox(width: 10),
                          Text(
                            'ADD TO CART',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: _subtext)),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _text),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: _border);
  }
}