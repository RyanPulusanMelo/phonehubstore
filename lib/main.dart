import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'homepage.dart';
import 'profile_page.dart';
import 'cart_page.dart';
import 'orders_page.dart';
import 'signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  final box = await Hive.openBox("phonehub_db");

  if (box.get("isDark") == null) box.put("isDark", false);
  if (box.get("biometrics") == null) box.put("biometrics", false);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = Hive.box("phonehub_db");

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = box.get("username") != null;

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: isLoggedIn ? LoginPage() : SignupPage(),
    );
  }
}

// ─────────────────────────────────────────────
// Login Page
// ─────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  final box = Hive.box("phonehub_db");

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String errorMsg = "";
  bool hidePassword = true;
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    isDark = box.get("isDark", defaultValue: false);
  }

  Color get _bg => isDark ? Color(0xFF0A0A0F) : Color(0xFFF0F4FF);
  Color get _card => isDark ? Color(0xFF12121E) : Color(0xFFFFFFFF);
  Color get _text => isDark ? Color(0xFFD0DCFF) : Color(0xFF0D1B4B);
  Color get _subtext => isDark ? Color(0xFF5A6A9A) : Color(0xFF6B7FA8);
  Color get _border => isDark ? Color(0xFF1E2A50) : Color(0xFFD0DCFF);

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool canAuthenticate =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (!canAuthenticate) {
        setState(() => errorMsg = "Biometrics not available on this device");
        return;
      }
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to sign in to PHONE HUB',
      );
      if (didAuthenticate) {
        _username.text = box.get("username");
        _password.text = box.get("password");
        _login();
      } else {
        setState(() => errorMsg = "Authentication failed");
      }
    } catch (e) {
      setState(() => errorMsg = "Biometric error: ${e.toString()}");
    }
  }

  void _login() {
    if (_username.text.trim() == box.get("username") &&
        _password.text.trim() == box.get("password")) {
      setState(() => errorMsg = "");
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => MainApp()),
      );
    } else {
      setState(() => errorMsg = "Invalid username or password");
    }
  }

  void _resetData() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Reset All Data"),
        content: Text(
            "This will permanently delete all your PHONE HUB account data."),
        actions: [
          CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('Reset'),
            onPressed: () async {
              Navigator.pop(context);
              final bool biometricsEnabled =
              box.get("biometrics", defaultValue: false);
              if (biometricsEnabled) {
                try {
                  final bool canAuth = await auth.canCheckBiometrics ||
                      await auth.isDeviceSupported();
                  if (!canAuth) {
                    setState(() =>
                    errorMsg = "Biometrics not available on this device");
                    return;
                  }
                  final bool didAuth = await auth.authenticate(
                    localizedReason:
                    'Authenticate to reset your PHONE HUB account',
                  );
                  if (!didAuth) {
                    setState(() => errorMsg = "Authentication failed");
                    return;
                  }
                } catch (e) {
                  setState(() => errorMsg = "Biometric error: ${e.toString()}");
                  return;
                }
              }
              box.delete("username");
              box.delete("password");
              box.delete("email");
              box.delete("fullName");
              box.delete("biometrics");
              box.delete("cartItems");
              box.delete("orderHistory");
              box.delete("accountCreated");
              box.put("isDark", false);
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => const SignupPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscure,
      keyboardType: keyboardType,
      prefix: Padding(
        padding: EdgeInsets.only(left: 14),
        child: Icon(icon, size: 18, color: _subtext),
      ),
      suffix: suffix,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      style: TextStyle(color: _text, fontSize: 15),
      placeholderStyle: TextStyle(color: _subtext, fontSize: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool biometricsEnabled = box.get("biometrics", defaultValue: false);

    return CupertinoPageScaffold(
      backgroundColor: _bg,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),

              // Logo section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0D1B4B), Color(0xFF2563EB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF2563EB).withOpacity(0.35),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/logo.png',
                          width: 78,
                          height: 78,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    Text(
                      'PHONE HUB',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                        color: _text,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Your premium phone store',
                      style: TextStyle(fontSize: 13, color: _subtext),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 56),

              Text(
                'Welcome back',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w800, color: _text),
              ),
              SizedBox(height: 4),
              Text(
                'Sign in to continue shopping',
                style: TextStyle(fontSize: 13, color: _subtext),
              ),
              SizedBox(height: 28),

              // Username field
              _buildTextField(
                controller: _username,
                placeholder: 'Username',
                icon: CupertinoIcons.person,
              ),
              SizedBox(height: 12),

              // Password field
              CupertinoTextField(
                controller: _password,
                placeholder: "Password",
                obscureText: hidePassword,
                prefix: Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Icon(CupertinoIcons.lock, size: 18, color: _subtext),
                ),
                suffix: CupertinoButton(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    hidePassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    size: 18,
                    color: _subtext,
                  ),
                  onPressed: () =>
                      setState(() => hidePassword = !hidePassword),
                ),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                ),
                style: TextStyle(color: _text, fontSize: 15),
                placeholderStyle: TextStyle(color: _subtext, fontSize: 15),
              ),

              SizedBox(height: 24),

              // Error Message
              if (errorMsg.isNotEmpty) ...[
                Center(
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF3B30).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      errorMsg,
                      style:
                      TextStyle(color: Color(0xFFFF3B30), fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Sign In Button
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _login,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2563EB).withOpacity(0.4),
                        blurRadius: 14,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Biometrics button
              if (biometricsEnabled) ...[
                SizedBox(height: 16),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _authenticateWithBiometrics,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _border),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.lock_shield_fill,
                              color: Color(0xFF2563EB), size: 20),
                          SizedBox(width: 10),
                          Text(
                            'SIGN IN WITH BIOMETRICS',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 30),

              Center(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Forgot your data? Reset Account',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: _resetData,
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Custom Tab Bar
// ─────────────────────────────────────────────
class _CustomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int cartCount;
  final bool hasOrders;
  final bool isDark;

  const _CustomTabBar({
    required this.currentIndex,
    required this.onTap,
    required this.cartCount,
    required this.hasOrders,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF0F0F1A) : const Color(0xFFFFFFFF);
    final border = isDark ? const Color(0xFF1E2A50) : const Color(0xFFD0DCFF);
    final activeColor = const Color(0xFF2563EB);
    final inactiveColor = isDark ? const Color(0xFF3A4A7A) : const Color(0xFF9AABCC);
    final pillColor = const Color(0xFF2563EB).withOpacity(0.12);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TabItem(
                icon: CupertinoIcons.device_phone_portrait,
                activeIcon: CupertinoIcons.device_phone_portrait,
                label: 'Store',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                pillColor: pillColor,
              ),
              _TabItem(
                icon: CupertinoIcons.cart,
                activeIcon: CupertinoIcons.cart_fill,
                label: 'Cart',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                pillColor: pillColor,
                badge: cartCount > 0 ? '$cartCount' : null,
              ),
              _TabItem(
                icon: CupertinoIcons.cube_box,
                activeIcon: CupertinoIcons.cube_box_fill,
                label: 'Orders',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                pillColor: pillColor,
                showDot: hasOrders,
              ),
              _TabItem(
                icon: CupertinoIcons.person,
                activeIcon: CupertinoIcons.person_fill,
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                pillColor: pillColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color pillColor;
  final String? badge;
  final bool showDot;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.pillColor,
    this.badge,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 44,
              height: 36,
              decoration: BoxDecoration(
                color: isActive ? pillColor : const Color(0x00000000),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    isActive ? activeIcon : icon,
                    size: 20,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                  if (badge != null)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                            minWidth: 16, minHeight: 16),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  if (showDot && badge == null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? activeColor : inactiveColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Main App with Custom Tab Navigation
// ─────────────────────────────────────────────
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final box = Hive.box("phonehub_db");
  bool isDark = false;
  int _currentIndex = 0;
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> orderHistory = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      isDark = box.get("isDark", defaultValue: false);

      final savedCart = box.get("cartItems");
      if (savedCart != null) {
        cartItems = (savedCart as List)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }

      final savedOrders = box.get("orderHistory");
      if (savedOrders != null) {
        orderHistory = (savedOrders as List)
            .map((order) => Map<String, dynamic>.from(order as Map))
            .toList();
      }
    });
  }

  void _saveCart() => box.put("cartItems", cartItems);
  void _saveOrders() => box.put("orderHistory", orderHistory);

  void addToCart(Map<String, dynamic> phone) {
    setState(() {
      int existingIndex = cartItems.indexWhere((item) =>
      item['name'] == phone['name'] &&
          item['selectedVariant'] == phone['selectedVariant']);

      if (existingIndex != -1) {
        cartItems[existingIndex]['quantity']++;
      } else {
        cartItems.add({...phone, 'quantity': 1});
      }
      _saveCart();
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
      _saveCart();
    });
  }

  void updateQuantity(int index, int quantity) {
    setState(() {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index]['quantity'] = quantity;
      }
      _saveCart();
    });
  }

  void clearCart() {
    setState(() {
      cartItems.clear();
      _saveCart();
    });
  }

  void addToOrderHistory(List<Map<String, dynamic>> items, int total) {
    setState(() {
      orderHistory.insert(0, {
        'orderId': 'PHB${DateTime.now().millisecondsSinceEpoch}',
        'items': items
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
        'total': total,
        'date': DateTime.now().toIso8601String(),
        'status': 'Processing',
        'trackingNumber':
        'TRK${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        'estimatedDelivery':
        DateTime.now().add(Duration(days: 3)).toIso8601String(),
        'shippingAddress': 'BGC, Taguig City, Metro Manila, PH',
      });
      _saveOrders();
    });
  }

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
      box.put("isDark", isDark);
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Homepage(onAddToCart: addToCart, isDark: isDark);
      case 1:
        return CartPage(
          cartItems: cartItems,
          onRemoveItem: removeFromCart,
          onUpdateQuantity: updateQuantity,
          onClearCart: clearCart,
          onOrderPlaced: addToOrderHistory,
          isDark: isDark,
        );
      case 2:
        return OrdersPage(
          orders: orderHistory
              .map((order) => {
            ...order,
            'date': DateTime.parse(order['date']),
            'estimatedDelivery':
            DateTime.parse(order['estimatedDelivery']),
          })
              .toList(),
          isDark: isDark,
        );
      case 3:
        return ProfilePage(isDark: isDark, onToggleTheme: toggleTheme);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:
      isDark ? const Color(0xFF0A0A0F) : const Color(0xFFF0F4FF),
      child: Column(
        children: [
          Expanded(
            child: _buildPage(_currentIndex),
          ),
          _CustomTabBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            cartCount: cartItems.length,
            hasOrders: orderHistory.isNotEmpty,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}