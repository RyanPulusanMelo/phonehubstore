import 'package:flutter/cupertino.dart';
import 'phonepage.dart';
import 'phone_specs_page.dart';

class Homepage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddToCart;
  final bool isDark;

  const Homepage({
    super.key,
    required this.onAddToCart,
    required this.isDark,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All', 'Apple', 'Samsung', 'Google', 'Xiaomi', 'OPPO', 'Vivo', 'OnePlus', 'Realme'
  ];

  Color get _bg => widget.isDark ? Color(0xFF0A0A0F) : Color(0xFFF0F4FF);
  Color get _card => widget.isDark ? Color(0xFF12121E) : Color(0xFFFFFFFF);
  Color get _text => widget.isDark ? Color(0xFFD0DCFF) : Color(0xFF0D1B4B);
  Color get _subtext => widget.isDark ? Color(0xFF5A6A9A) : Color(0xFF6B7FA8);
  Color get _border => widget.isDark ? Color(0xFF1E2A50) : Color(0xFFD0DCFF);

  final List<Map<String, dynamic>> phones = [
    {
      'name': 'iPhone 16 Pro Max',
      'brand': 'Apple',
      'price': 74999,
      'category': 'Apple',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/apple-iphone-16-pro-max.jpg',
      'description': 'The most powerful iPhone ever. Featuring the A18 Pro chip, a stunning 6.9" Super Retina XDR display with ProMotion, and the all-new Camera Control.',
      'variants': ['256GB', '512GB', '1TB'],
      'specs': ['Apple', 'iOS 18', '6.9 inch OLED'],
      'rating': 4.9,
      'reviews': 38201,
      'storage': '256GB / 512GB / 1TB',
      'display': '6.9" Super Retina XDR OLED',
      'processor': 'Apple A18 Pro',
      'camera': '48MP + 48MP + 12MP Triple',
      'battery': '4685 mAh',
      'os': 'iOS 18',
      'excerpt': 'iPhone 16 Pro Max. Forged in titanium and featuring the groundbreaking A18 Pro chip, it brings you next-level intelligence. The improved Neural Engine processes AI tasks at unprecedented speed. Camera Control gives you an intuitive new way to use the camera — quickly access tools, use App Clip codes or Visual Intelligence. And with the most advanced iPhone camera system ever — featuring a 48MP Fusion camera, 5x Telephoto, and the new 48MP Ultra Wide — every shot is extraordinary.',
    },
    {
      'name': 'iPhone 16',
      'brand': 'Apple',
      'price': 54999,
      'category': 'Apple',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/apple-iphone-16.jpg',
      'description': 'iPhone 16. Built for Apple Intelligence. With the all-new A18 chip, Camera Control, and a beautiful 6.1-inch display.',
      'variants': ['128GB', '256GB', '512GB'],
      'specs': ['Apple', 'iOS 18', '6.1 inch OLED'],
      'rating': 4.8,
      'reviews': 21043,
      'storage': '128GB / 256GB / 512GB',
      'display': '6.1" Super Retina XDR OLED',
      'processor': 'Apple A18',
      'camera': '48MP + 12MP Dual',
      'battery': '3561 mAh',
      'os': 'iOS 18',
      'excerpt': 'iPhone 16. A new era of iPhone. Meet Camera Control — a dedicated hardware button giving you instant access to the camera. The powerful A18 chip is built on 3nm technology, enabling Apple Intelligence features like Writing Tools, Image Playground, and a more personal Siri. All housed in an aerospace-grade aluminum body available in five stunning colors.',
    },
    {
      'name': 'Samsung Galaxy S25 Ultra',
      'brand': 'Samsung',
      'price': 79999,
      'category': 'Samsung',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/samsung-galaxy-s25-ultra.jpg',
      'description': 'Galaxy AI is here. The Galaxy S25 Ultra with Snapdragon 8 Elite and the iconic built-in S Pen redefines what a smartphone can do.',
      'variants': ['256GB', '512GB', '1TB'],
      'specs': ['Samsung', 'Android 15', '6.9 inch Dynamic AMOLED'],
      'rating': 4.9,
      'reviews': 29403,
      'storage': '256GB / 512GB / 1TB',
      'display': '6.9" QHD+ Dynamic AMOLED 2X 120Hz',
      'processor': 'Snapdragon 8 Elite',
      'camera': '200MP + 50MP + 10MP + 50MP Quad',
      'battery': '5000 mAh',
      'os': 'Android 15 / One UI 7',
      'excerpt': 'Galaxy S25 Ultra. The phone that thinks with you. Equipped with Snapdragon 8 Elite for Galaxy, it delivers AI-powered features that understand your needs. The 200MP main camera captures breathtaking detail. The integrated S Pen lets you sketch, translate, and annotate naturally. With 7 years of OS updates, this is a phone that truly grows with you.',
    },
    {
      'name': 'Samsung Galaxy S25+',
      'brand': 'Samsung',
      'price': 59999,
      'category': 'Samsung',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/samsung-galaxy-s25+.jpg',
      'description': 'Galaxy S25+ with Snapdragon 8 Elite, 6.7" QHD+ Dynamic AMOLED 2X display and Galaxy AI built in.',
      'variants': ['256GB', '512GB'],
      'specs': ['Samsung', 'Android 15', '6.7 inch Dynamic AMOLED'],
      'rating': 4.8,
      'reviews': 17823,
      'storage': '256GB / 512GB',
      'display': '6.7" QHD+ Dynamic AMOLED 2X 120Hz',
      'processor': 'Snapdragon 8 Elite',
      'camera': '50MP + 12MP + 10MP Triple',
      'battery': '4900 mAh',
      'os': 'Android 15 / One UI 7',
      'excerpt': 'Galaxy S25+. The perfect balance of power and portability. Galaxy AI transforms how you interact with your phone — from Live Translate in calls to Circle to Search and real-time note-taking. The vivid 6.7" display adapts intelligently to your content, and the titanium frame keeps it premium yet light.',
    },
    {
      'name': 'Google Pixel 9 Pro XL',
      'brand': 'Google',
      'price': 62999,
      'category': 'Google',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/google-pixel-9-pro-xl.jpg',
      'description': 'The most pro Pixel ever. Google\'s most powerful chip, the Tensor G4, with a stunning 6.8" display and the best Google AI on any phone.',
      'variants': ['256GB', '512GB', '1TB'],
      'specs': ['Google', 'Android 15', '6.8 inch LTPO OLED'],
      'rating': 4.8,
      'reviews': 14901,
      'storage': '256GB / 512GB / 1TB',
      'display': '6.8" LTPO OLED 1-120Hz',
      'processor': 'Google Tensor G4',
      'camera': '50MP + 48MP + 48MP Triple',
      'battery': '5060 mAh',
      'os': 'Android 15',
      'excerpt': 'Pixel 9 Pro XL. Google AI built in. With Gemini Live, you can have natural back-and-forth conversations with Google\'s most capable AI. Add Me to your group photos. Use Best Take to get the perfect shot from everyone. And with Tensor G4 on-device processing, your data stays private.',
    },
    {
      'name': 'Xiaomi 14 Ultra',
      'brand': 'Xiaomi',
      'price': 49999,
      'category': 'Xiaomi',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/xiaomi-14-ultra.jpg',
      'description': 'Leica photography redefined. The Xiaomi 14 Ultra brings professional-grade photography to your pocket with Snapdragon 8 Gen 3.',
      'variants': ['256GB', '512GB', '1TB'],
      'specs': ['Xiaomi', 'Android 14', '6.73 inch LTPO AMOLED'],
      'rating': 4.7,
      'reviews': 9821,
      'storage': '256GB / 512GB / 1TB',
      'display': '6.73" LTPO AMOLED 1-120Hz',
      'processor': 'Snapdragon 8 Gen 3',
      'camera': '50MP + 50MP + 50MP + 50MP Quad Leica',
      'battery': '5000 mAh',
      'os': 'Android 14 / HyperOS',
      'excerpt': 'Xiaomi 14 Ultra. Co-engineered with Leica. Four Leica Summilux lenses — all 50MP — cover every focal length from ultrawide to 5x telephoto. The one-inch main sensor captures extraordinary light. The Photography Kit accessory transforms it into a true mirrorless-style shooter. Pure Leica Authentic or Leica Vibrant tone modes give your photos a signature aesthetic.',
    },
    {
      'name': 'OPPO Find X8 Pro',
      'brand': 'OPPO',
      'price': 44999,
      'category': 'OPPO',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/oppo-find-x8-pro.jpg',
      'description': 'OPPO Find X8 Pro with Hasselblad cameras and Dimensity 9400. A masterpiece of design and imaging.',
      'variants': ['256GB', '512GB'],
      'specs': ['OPPO', 'Android 15', '6.78 inch LTPO AMOLED'],
      'rating': 4.7,
      'reviews': 7203,
      'storage': '256GB / 512GB',
      'display': '6.78" LTPO AMOLED 1-120Hz',
      'processor': 'MediaTek Dimensity 9400',
      'camera': '50MP + 50MP + 50MP Triple Hasselblad',
      'battery': '5910 mAh',
      'os': 'Android 15 / ColorOS 15',
      'excerpt': 'OPPO Find X8 Pro. Every detail, perfected. Three Hasselblad-tuned cameras with periscope telephoto and professional color science. The 5910mAh silicon-carbon battery charges wirelessly at 50W. The ultra-slim ceramic back and titanium-alloy frame make this one of the most premium-feeling phones ever crafted.',
    },
    {
      'name': 'OnePlus 13',
      'brand': 'OnePlus',
      'price': 39999,
      'category': 'OnePlus',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/oneplus-13.jpg',
      'description': 'OnePlus 13. Hasselblad cameras, 100W SUPERVOOC fast charging, and Snapdragon 8 Elite. Never Settle.',
      'variants': ['256GB', '512GB', '1TB'],
      'specs': ['OnePlus', 'Android 15', '6.82 inch LTPO AMOLED'],
      'rating': 4.7,
      'reviews': 11204,
      'storage': '256GB / 512GB / 1TB',
      'display': '6.82" LTPO AMOLED 1-120Hz',
      'processor': 'Snapdragon 8 Elite',
      'camera': '50MP + 50MP + 50MP Triple Hasselblad',
      'battery': '6000 mAh',
      'os': 'Android 15 / OxygenOS 15',
      'excerpt': 'OnePlus 13. Engineered without compromise. The 6000mAh battery with 100W SUPERVOOC wired and 50W wireless charging means you are always powered up. Snapdragon 8 Elite combined with 16GB RAM ensures buttery-smooth performance. Hasselblad Natural Color Calibration delivers true-to-life photos in any condition.',
    },
    {
      'name': 'Realme GT 7 Pro',
      'brand': 'Realme',
      'price': 29999,
      'category': 'Realme',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/realme-gt-7-pro.jpg',
      'description': 'Realme GT 7 Pro. Snapdragon 8 Elite, 120W charging, and innovative temperature sensors. Flagship power, accessible price.',
      'variants': ['256GB', '512GB'],
      'specs': ['Realme', 'Android 15', '6.78 inch LTPO AMOLED'],
      'rating': 4.6,
      'reviews': 8312,
      'storage': '256GB / 512GB',
      'display': '6.78" LTPO AMOLED 1-120Hz',
      'processor': 'Snapdragon 8 Elite',
      'camera': '50MP + 8MP + 50MP Triple',
      'battery': '6500 mAh',
      'os': 'Android 15 / Realme UI 6.0',
      'excerpt': 'Realme GT 7 Pro. Elite performance meets bold value. The industry-first infrared temperature sensor measures body and environmental temperature in seconds. 120W SUPERVOOC charges the massive 6500mAh battery from 0 to 100% in just 36 minutes. Snapdragon 8 Elite with the Adreno 830 GPU handles any game at maximum settings without breaking a sweat.',
    },
    {
      'name': 'Vivo X200 Pro',
      'brand': 'Vivo',
      'price': 47999,
      'category': 'Vivo',
      'image': 'https://fdn2.gsmarena.com/vv/bigpics/vivo-x200-pro.jpg',
      'description': 'Vivo X200 Pro with ZEISS optics, Dimensity 9400 and a massive 6000mAh silicon-carbon battery.',
      'variants': ['256GB', '512GB', '1TB'],
      'specs': ['Vivo', 'Android 15', '6.78 inch LTPO AMOLED'],
      'rating': 4.7,
      'reviews': 6109,
      'storage': '256GB / 512GB / 1TB',
      'display': '6.78" LTPO AMOLED 1-120Hz',
      'processor': 'MediaTek Dimensity 9400',
      'camera': '50MP + 50MP + 200MP Triple ZEISS',
      'battery': '6000 mAh',
      'os': 'Android 15 / OriginOS 5',
      'excerpt': 'Vivo X200 Pro. Photography with purpose. The 200MP ZEISS APO Telephoto lens delivers unprecedented detail at a distance. ZEISS T* coating reduces lens flare and ghosting for professional-grade clarity. Dimensity 9400 ensures AI photography tasks run seamlessly. The 90W wireless charging is the fastest in its class.',
    },
  ];

  List<Map<String, dynamic>> get filteredPhones {
    if (selectedCategory == 'All') return phones;
    return phones.where((p) => p['category'] == selectedCategory).toList();
  }

  void _showSpecsPreview(Map<String, dynamic> phone) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 16),
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
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 96,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _border),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                phone['image'],
                                fit: BoxFit.contain,
                                errorBuilder: (c, e, s) => Center(
                                    child: Text('📱',
                                        style: TextStyle(fontSize: 32))),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(phone['name'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: _text),
                                    maxLines: 2),
                                SizedBox(height: 4),
                                Text(phone['brand'],
                                    style: TextStyle(
                                        fontSize: 13, color: _subtext)),
                                SizedBox(height: 8),
                                Text('₱${phone['price']}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF2563EB))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text('QUICK SPECS',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              color: _subtext)),
                      SizedBox(height: 12),
                      _buildSpecRow('Display', phone['display']),
                      _buildSpecRow('Processor', phone['processor']),
                      _buildSpecRow('Camera', phone['camera']),
                      _buildSpecRow('Battery', phone['battery']),
                      _buildSpecRow('OS', phone['os']),
                      SizedBox(height: 20),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => PhoneDetailPage(
                                phone: phone,
                                onAddToCart: widget.onAddToCart,
                                isDark: widget.isDark,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xFF1E40AF), Color(0xFF2563EB)]),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text('VIEW FULL DETAILS',
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5)),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: TextStyle(fontSize: 12, color: _subtext)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _text)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: _bg,
      child: CustomScrollView(
        slivers: [
          // Navigation Bar
          CupertinoSliverNavigationBar(
            backgroundColor: widget.isDark
                ? Color(0xFF0A0A0F).withOpacity(0.95)
                : Color(0xFFF0F4FF).withOpacity(0.95),
            border: null,
            largeTitle: Text(
              'PHONE HUB',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: _text,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF2563EB).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${filteredPhones.length} phones',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),

          // Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.isDark
                        ? [Color(0xFF0D1B4B), Color(0xFF1E3A8A)]
                        : [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latest Flagship\nPhones 2025',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFFFFFF),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Free shipping on orders ₱5,000+',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFBFD0FF),
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Shop Now →',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('📱', style: TextStyle(fontSize: 64)),
                  ],
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat),
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF2563EB) : _card,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: isSelected
                                ? Color(0xFF2563EB)
                                : _border),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                              color: Color(0xFF2563EB).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 3))
                        ]
                            : null,
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? Color(0xFFFFFFFF)
                              : _subtext,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Phones grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildPhoneCard(filteredPhones[index]),
                childCount: filteredPhones.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildPhoneCard(Map<String, dynamic> phone) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PhoneDetailPage(
              phone: phone,
              onAddToCart: widget.onAddToCart,
              isDark: widget.isDark,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2563EB).withOpacity(widget.isDark ? 0.1 : 0.07),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(15)),
                  color: widget.isDark
                      ? Color(0xFF1A1A2E)
                      : Color(0xFFEEF2FF)),
              child: ClipRRect(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.network(
                    phone['image'],
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Color(0xFF2563EB).withOpacity(0.1),
                      child: Center(
                          child: Text('📱',
                              style: TextStyle(fontSize: 48))),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phone['name'],
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _text,
                        height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3),
                  Text(phone['brand'],
                      style: TextStyle(fontSize: 11, color: _subtext),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(CupertinoIcons.star_fill,
                          size: 11, color: Color(0xFFFFAA00)),
                      SizedBox(width: 3),
                      Text('${phone['rating']}',
                          style: TextStyle(fontSize: 11, color: _subtext)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₱${phone['price']}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: _text),
                      ),
                      GestureDetector(
                        onTap: () => _showSpecsPreview(phone),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color:
                            Color(0xFF2563EB).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Color(0xFF2563EB)
                                    .withOpacity(0.3)),
                          ),
                          child: Icon(
                              CupertinoIcons.info_circle,
                              size: 13,
                              color: Color(0xFF2563EB)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}