import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemoveItem;
  final Function(int, int) onUpdateQuantity;
  final Function() onClearCart;
  final Function(List<Map<String, dynamic>>, int) onOrderPlaced;
  final bool isDark;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveItem,
    required this.onUpdateQuantity,
    required this.onClearCart,
    required this.onOrderPlaced,
    required this.isDark,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String key = "xnd_development_hv67wthoiNF1QBFXlyauMn4Oy63vVL37nkXAAmWpeoVgHel1tep0QNiFRa1m21uP";
  Timer? _pollingTimer;
  bool _orderPlaced = false;

  Color get _accent => Color(0xFF2563EB);
  Color get _bg => widget.isDark ? Color(0xFF0A0A0F) : Color(0xFFF0F4FF);
  Color get _card => widget.isDark ? Color(0xFF12121E) : Color(0xFFFFFFFF);
  Color get _text => widget.isDark ? Color(0xFFD0DCFF) : Color(0xFF0D1B4B);
  Color get _subtext => widget.isDark ? Color(0xFF5A6A9A) : Color(0xFF6B7FA8);
  Color get _border => widget.isDark ? Color(0xFF1E2A50) : Color(0xFFD0DCFF);

  int get totalAmount {
    return widget.cartItems.fold(
        0,
            (sum, item) =>
        sum + (item['price'] as int) * (item['quantity'] as int));
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> payNow(int price) async {
    _orderPlaced = false;

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Preparing Checkout"),
        content: Padding(
          padding: EdgeInsets.only(top: 20),
          child: CupertinoActivityIndicator(),
        ),
      ),
    );

    final url = "https://api.xendit.co/v2/invoices";
    String auth = 'Basic ' + base64Encode(utf8.encode('$key:'));

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": auth,
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "external_id":
          "phonehub_" + DateTime.now().millisecondsSinceEpoch.toString(),
          "amount": price
        }),
      );

      final data = jsonDecode(response.body);
      String id = data["id"];

      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              PaymentPage(url: data["invoice_url"], isDark: widget.isDark),
        ),
      );

      paymentPolling(id, auth);
    } catch (e) {
      Navigator.pop(context);
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Error'),
          content: Text('Failed to create payment. Please try again.'),
          actions: [
            CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context)),
          ],
        ),
      );
    }
  }

  Future<void> paymentPolling(String id, String auth) async {
    _pollingTimer?.cancel();

    _pollingTimer =
        Timer.periodic(Duration(seconds: 5), (timer) async {
          final url = "https://api.xendit.co/v2/invoices/" + id;

          try {
            final response = await http.get(Uri.parse(url),
                headers: {"Authorization": auth});
            final data = jsonDecode(response.body);

            if (data["status"] == "PAID" && !_orderPlaced) {
              _orderPlaced = true;
              timer.cancel();
              _pollingTimer?.cancel();

              final orderItems = widget.cartItems
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList();
              final orderTotal = totalAmount;

              widget.onOrderPlaced(orderItems, orderTotal);
              widget.onClearCart();

              if (Navigator.canPop(context)) Navigator.pop(context);

              if (mounted) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text('Order Placed! 📱'),
                    content: Text(
                        'Your phones are on their way! Enjoy your new device.'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('Continue Shopping'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              }
            }
          } catch (e) {
            print("Polling error: $e");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: _bg,
      child: SafeArea(
        child: widget.cartItems.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('📱', style: TextStyle(fontSize: 72)),
              SizedBox(height: 20),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _text,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add some phones to get started!',
                style: TextStyle(fontSize: 14, color: _subtext),
              ),
            ],
          ),
        )
            : Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MY CART',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          color: _text,
                        ),
                      ),
                      Text(
                        '${widget.cartItems.length} ${widget.cartItems.length == 1 ? 'item' : 'items'}',
                        style: TextStyle(
                            fontSize: 13, color: _subtext),
                      ),
                    ],
                  ),
                  if (widget.cartItems.isNotEmpty)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF3B30).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            color: Color(0xFFFF3B30),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text('Clear Cart'),
                            content: Text(
                                'Remove all items from your cart?'),
                            actions: [
                              CupertinoDialogAction(
                                  child: Text('Cancel'),
                                  onPressed: () =>
                                      Navigator.pop(context)),
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                child: Text('Clear'),
                                onPressed: () {
                                  widget.onClearCart();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: _buildCartItem(
                        widget.cartItems[index], index),
                  );
                },
              ),
            ),

            // Checkout
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _card,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                    top: BorderSide(color: _border, width: 1)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF2563EB).withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: _subtext,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '₱${totalAmount}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: _text,
                          ),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => payNow(totalAmount),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF1E40AF),
                              Color(0xFF2563EB)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color:
                              Color(0xFF2563EB).withOpacity(0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'CHECKOUT',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 1),
        boxShadow: [
          BoxShadow(
            color:
            Color(0xFF2563EB).withOpacity(widget.isDark ? 0.1 : 0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Phone image
          Container(
            width: 70,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.isDark
                  ? Color(0xFF1A1A2E)
                  : Color(0xFFEEF2FF),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Image.network(
                  item['image'],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                      child: Text('📱',
                          style: TextStyle(fontSize: 28))),
                ),
              ),
            ),
          ),
          SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3),
                Text(
                  item['brand'] ?? item['author'] ?? '',
                  style: TextStyle(fontSize: 12, color: _subtext),
                ),
                SizedBox(height: 3),
                Text(
                  item['selectedVariant'] ??
                      item['selectedColor'] ??
                      '',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '₱${item['price']}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: _text,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => widget.onUpdateQuantity(
                        index, item['quantity'] - 1),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? Color(0xFF1A1A2E)
                            : Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _border),
                      ),
                      child: Icon(CupertinoIcons.minus,
                          size: 14, color: _text),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${item['quantity']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _text,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => widget.onUpdateQuantity(
                        index, item['quantity'] + 1),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(CupertinoIcons.add,
                          size: 14, color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () => widget.onRemoveItem(index),
                child: Icon(CupertinoIcons.delete,
                    size: 20, color: Color(0xFFFF3B30)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final String url;
  final bool isDark;

  const PaymentPage(
      {super.key, required this.url, required this.isDark});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: widget.isDark
          ? Color(0xFF0A0A0F)
          : Color(0xFFF0F4FF),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.isDark
            ? Color(0xFF0A0A0F).withOpacity(0.95)
            : Color(0xFFF0F4FF).withOpacity(0.95),
        middle: Text(
          "Secure Payment",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: widget.isDark
                ? Color(0xFFD0DCFF)
                : Color(0xFF0D1B4B),
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.back,
            color: widget.isDark
                ? Color(0xFFD0DCFF)
                : Color(0xFF0D1B4B),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}