import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'main.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final box = Hive.box("phonehub_db");
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  String errorMsg = "";
  bool hidePassword = true;
  bool hideConfirmPassword = true;
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

  Future<void> _signup() async {
    if (_username.text.trim().isEmpty) {
      setState(() => errorMsg = "Username is required");
      return;
    }
    if (_password.text.trim().isEmpty) {
      setState(() => errorMsg = "Password is required");
      return;
    }
    if (_password.text.trim().length < 6) {
      setState(() => errorMsg = "Password must be at least 6 characters");
      return;
    }
    if (_password.text.trim() != _confirmPassword.text.trim()) {
      setState(() => errorMsg = "Passwords do not match");
      return;
    }

    box.put("username", _username.text.trim());
    box.put("password", _password.text.trim());
    box.put("biometrics", false);
    box.put("accountCreated", DateTime.now().toIso8601String());

    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Account Created! 📱'),
        content: Text(
            'Your account has been successfully created. Please sign in to continue.'),
        actions: [
          CupertinoDialogAction(
            child: Text('Sign In'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (context) => LoginPage()),
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
        child: Icon(icon, size: 18),
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
    return CupertinoPageScaffold(
      backgroundColor: _bg,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),

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
                        child: Text('📱', style: TextStyle(fontSize: 38)),
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

              SizedBox(height: 40),

              Text(
                'Create Account',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w800, color: _text),
              ),
              SizedBox(height: 4),
              Text(
                'Join thousands of shoppers on PHONE HUB',
                style: TextStyle(fontSize: 13, color: _subtext),
              ),
              SizedBox(height: 28),

              // Username
              _buildTextField(
                controller: _username,
                placeholder: 'Username',
                icon: CupertinoIcons.person,
              ),
              SizedBox(height: 12),

              // Password
              _buildTextField(
                controller: _password,
                placeholder: 'Password',
                icon: CupertinoIcons.lock,
                obscure: hidePassword,
                suffix: CupertinoButton(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    hidePassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    size: 18,
                  ),
                  onPressed: () =>
                      setState(() => hidePassword = !hidePassword),
                ),
              ),
              SizedBox(height: 12),

              // Confirm Password
              _buildTextField(
                controller: _confirmPassword,
                placeholder: 'Confirm Password',
                icon: CupertinoIcons.lock_fill,
                obscure: hideConfirmPassword,
                suffix: CupertinoButton(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    hideConfirmPassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    size: 18,
                  ),
                  onPressed: () => setState(
                          () => hideConfirmPassword = !hideConfirmPassword),
                ),
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

              // Create Account Button
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _signup,
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
                      'CREATE ACCOUNT',
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

              SizedBox(height: 20),

              // Already have account
              Center(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Already have an account? Sign In',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
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