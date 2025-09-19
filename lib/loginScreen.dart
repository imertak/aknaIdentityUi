import 'package:akna_ui/emailVerificationScreen.dart';
import 'package:akna_ui/forgotPasswordScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AknaApp());
}

class AknaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AKNA',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'SF Pro Display',
      ),
      home: WelcomeScreen(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),

                  // Animated Logo ve araç görseliii
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color(0xFFF7FAFC),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF2D3748),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          color: Color(0xFF2D3748),
                          size: 60,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Animated App Title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'AKNA',
                          style: TextStyle(
                            color: Color(0xFF2D3748),
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),

                        SizedBox(height: 6),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF3182CE).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color(0xFF3182CE).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Türkiye\'nin Freight Platformu',
                            style: TextStyle(
                              color: Color(0xFF3182CE),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        Text(
                          'Yük Taşımacılığında Yeni Dönem\nHızlı • Güvenli • Ekonomik',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF718096),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Animated Stats
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("1000+", "Aktif Sürücü"),
                          Container(
                            width: 1,
                            height: 30,
                            color: Color(0xFFE2E8F0),
                          ),
                          _buildStatItem("50+", "Şehir"),
                          Container(
                            width: 1,
                            height: 30,
                            color: Color(0xFFE2E8F0),
                          ),
                          _buildStatItem("99%", "Memnuniyet"),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Animated Get Started Button
                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      LoginScreen(),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                return SlideTransition(
                                  position: animation.drive(
                                    Tween(
                                      begin: Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D3748),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          shadowColor: Color(0xFF2D3748).withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Başlayalım',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Animated Features
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            Icons.verified_user_rounded,
                            'GÜVENLİ &\nSertifikalı',
                            'SSL şifreleme\nve güvenli ödeme',
                            Color(0xFF38A169),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildFeatureCard(
                            Icons.speed_rounded,
                            'HIZLI\nTeslim',
                            'Anlık takip\nve bildirimler',
                            Color(0xFF3182CE),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildFeatureCard(
                            Icons.attach_money_rounded,
                            'EKONOMİK\nFiyatlar',
                            'En uygun\nnakliye ücretleri',
                            Color(0xFFED8936),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF718096),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String subtitle,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withOpacity(0.2)),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutQuart),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF4A5568)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    // Title
                    Text(
                      'Giriş Yap',
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'AKNA hesabınıza giriş yapın ve nakliye işlemlerinizi kolayca yönetin.',
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 40),

                    // Email Field
                    _buildInputLabel('E-posta Adresi'),
                    SizedBox(height: 8),

                    _buildInputField(
                      controller: _emailController,
                      hintText: 'ornek@akna.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline_rounded,
                    ),

                    SizedBox(height: 24),

                    // Password Field
                    _buildInputLabel('Şifre'),
                    SizedBox(height: 8),

                    _buildInputField(
                      controller: _passwordController,
                      hintText: 'Şifrenizi girin',
                      obscureText: !_isPasswordVisible,
                      prefixIcon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: Color(0xFF718096),
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 16),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ForgotPasswordScreen(),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                return SlideTransition(
                                  position: animation.drive(
                                    Tween(
                                      begin: Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Şifremi Unuttum?',
                          style: TextStyle(
                            color: Color(0xFF3182CE),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Login Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  if (_emailController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    _showErrorSnackBar(
                                      'Lütfen tüm alanları doldurun',
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  // Simulate login
                                  Future.delayed(Duration(seconds: 2), () {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    print('Login: ${_emailController.text}');
                                  });
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D3748),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: Color(0xFF718096),
                        ),
                        child:
                            _isLoading
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Giriş yapılıyor...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Giriş Yap',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, size: 20),
                                  ],
                                ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Spacer
                    SizedBox(height: 48),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hesabın yok mu? ',
                          style: TextStyle(
                            color: Color(0xFF718096),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        RegisterScreen(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return SlideTransition(
                                    position: animation.drive(
                                      Tween(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Kayıt Ol',
                            style: TextStyle(
                              color: Color(0xFF3182CE),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Color(0xFF2D3748),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xFF718096),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon:
              prefixIcon != null
                  ? Container(
                    margin: EdgeInsets.all(12),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE2E8F0)),
                    ),
                    child: Icon(prefixIcon, color: Color(0xFF718096), size: 18),
                  )
                  : null,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1 Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Step 2 Controllers
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Step 3 Variables
  String _selectedUserType = 'Shipper';
  String _selectedAccountStatus = 'Active';

  // Error messages - Sadece buton tıklandıktan sonra gösterilecek
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Validasyon yapılıp yapılmadığını takip eden değişkenler
  bool _step1Validated = false;
  bool _step2Validated = false;

  final List<String> _userTypes = ['Shipper', 'Carrier', 'Driver'];
  final List<String> _accountStatuses = ['Active', 'Pending'];

  @override
  void initState() {
    super.initState();

    // Sadece validasyon yapıldıktan sonra düzeltme için listener'lar ekle
    _firstNameController.addListener(_onStep1FieldChanged);
    _lastNameController.addListener(_onStep1FieldChanged);
    _emailController.addListener(_onStep1FieldChanged);
    _phoneController.addListener(_onStep1FieldChanged);
    _passwordController.addListener(_onStep2FieldChanged);
    _confirmPasswordController.addListener(_onStep2FieldChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Step 1 alanları değiştiğinde çağrılır (sadece validasyon yapıldıysa)
  void _onStep1FieldChanged() {
    if (_step1Validated) {
      _validateStep1Fields();
    }
  }

  // Step 2 alanları değiştiğinde çağrılır (sadece validasyon yapıldıysa)
  void _onStep2FieldChanged() {
    if (_step2Validated) {
      _validateStep2Fields();
    }
    // Şifre gereksinimleri için anlık güncelleme (her zaman)
    setState(() {
      // Bu sadece UI'ı güncellemek için, hata mesajları _step2Validated kontrolüne bağlı
    });
  }

  void _validateStep1Fields() {
    setState(() {
      // First Name validation
      if (_firstNameController.text.isEmpty) {
        _firstNameError = 'Ad alanı zorunludur';
      } else if (_firstNameController.text.length < 2) {
        _firstNameError = 'Ad en az 2 karakter olmalıdır';
      } else {
        _firstNameError = null;
      }

      // Last Name validation
      if (_lastNameController.text.isEmpty) {
        _lastNameError = 'Soyad alanı zorunludur';
      } else if (_lastNameController.text.length < 2) {
        _lastNameError = 'Soyad en az 2 karakter olmalıdır';
      } else {
        _lastNameError = null;
      }

      // Email validation
      if (_emailController.text.isEmpty) {
        _emailError = 'E-posta alanı zorunludur';
      } else if (!_emailController.text.contains('@') ||
          !_emailController.text.contains('.')) {
        _emailError = 'Geçerli bir e-posta adresi girin';
      } else {
        _emailError = null;
      }

      // Phone validation
      if (_phoneController.text.isEmpty) {
        _phoneError = 'Telefon numarası zorunludur';
      } else if (_phoneController.text.length < 10) {
        _phoneError = 'Geçerli bir telefon numarası girin';
      } else {
        _phoneError = null;
      }
    });
  }

  void _validateStep2Fields() {
    setState(() {
      // Password validation
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Şifre alanı zorunludur';
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Şifre en az 6 karakter olmalıdır';
      } else if (!_passwordController.text.contains(RegExp(r'[A-Za-z]'))) {
        _passwordError = 'Şifre en az bir harf içermelidir';
      } else {
        _passwordError = null;
      }

      // Confirm Password validation
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Şifre tekrar alanı zorunludur';
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = 'Şifreler eşleşmiyor';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _nextStep() {
    if (_currentStep == 0) {
      setState(() {
        _step1Validated = true;
      });
      _validateStep1Fields();
      if (!_validateStep1()) {
        _showErrorSnackBar('Lütfen tüm alanları doğru şekilde doldurun');
        return;
      }
    } else if (_currentStep == 1) {
      setState(() {
        _step2Validated = true;
      });
      _validateStep2Fields();
      if (!_validateStep2()) {
        _showErrorSnackBar('Lütfen şifre gereksinimlerini kontrol edin');
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateStep1() {
    return _firstNameError == null &&
        _lastNameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
  }

  bool _validateStep2() {
    return _passwordError == null &&
        _confirmPasswordError == null &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Color(0xFF38A169).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF38A169),
                size: 16,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(message, style: TextStyle(color: Color(0xFF2D3748))),
            ),
          ],
        ),
        backgroundColor: Color(0xFFF0FFF4),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
    );
  }

  void _register() {
    // Final validation
    setState(() {
      _step1Validated = true;
      _step2Validated = true;
    });
    _validateStep1Fields();
    _validateStep2Fields();

    if (!_validateStep1() || !_validateStep2()) {
      _showErrorSnackBar('Lütfen tüm alanları doğru şekilde doldurun');
      return;
    }

    // Kayıt işlemi burada yapılacak
    print('Register User:');
    print('Name: ${_firstNameController.text} ${_lastNameController.text}');
    print('Email: ${_emailController.text}');
    print('Phone: ${_phoneController.text}');
    print('Password: ${_passwordController.text}');
    print('UserType: $_selectedUserType');
    print('AccountStatus: $_selectedAccountStatus');

    // Başarılı kayıt mesajı
    _showSuccessSnackBar('Kayıt başarılı! Giriş yapabilirsiniz.');
    navigateToEmailVerification(
      context,
      _emailController.text,
      _phoneController.text,
    );
  }

  // Kayıt başarılı olduğunda e-posta doğrulama sayfasına git
  void navigateToEmailVerification(
    BuildContext context,
    String email,
    String phoneNumber,
  ) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                EmailVerificationScreen(email: email, phoneNumber: phoneNumber),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: Offset(1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF4A5568)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Kayıt Ol ${_currentStep + 1}/3',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color:
                            index <= _currentStep
                                ? Color(0xFF3182CE)
                                : Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [_buildStep1(), _buildStep2(), _buildStep3()],
              ),
            ),

            // Navigation Buttons
            Container(
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: Container(
                        height: 56,
                        margin: EdgeInsets.only(right: 12),
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xFF3182CE)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Geri',
                            style: TextStyle(
                              color: Color(0xFF3182CE),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: _currentStep > 0 ? 1 : 1,
                    child: Container(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentStep == 0) {
                            _nextStep();
                          } else if (_currentStep == 1) {
                            _nextStep();
                          } else if (_currentStep == 2) {
                            _register();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D3748),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentStep == 2 ? 'Kayıt Ol' : 'Devam Et',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kişisel Bilgiler',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Hesabınızı oluşturmak için kişisel bilgilerinizi girin',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 32),

          // First Name
          _buildInputLabel('Ad'),
          SizedBox(height: 8),

          _buildInputField(
            controller: _firstNameController,
            hintText: 'Adınız',
            hasError: _step1Validated && _firstNameError != null,
            isValid:
                _step1Validated &&
                _firstNameError == null &&
                _firstNameController.text.isNotEmpty,
          ),

          if (_step1Validated && _firstNameError != null)
            _buildErrorText(_firstNameError!),

          SizedBox(height: 20),

          // Last Name
          _buildInputLabel('Soyad'),
          SizedBox(height: 8),

          _buildInputField(
            controller: _lastNameController,
            hintText: 'Soyadınız',
            hasError: _step1Validated && _lastNameError != null,
            isValid:
                _step1Validated &&
                _lastNameError == null &&
                _lastNameController.text.isNotEmpty,
          ),

          if (_step1Validated && _lastNameError != null)
            _buildErrorText(_lastNameError!),

          SizedBox(height: 20),

          // Email
          _buildInputLabel('E-posta'),
          SizedBox(height: 8),

          _buildInputField(
            controller: _emailController,
            hintText: 'ornek@akna.com',
            keyboardType: TextInputType.emailAddress,
            hasError: _step1Validated && _emailError != null,
            isValid:
                _step1Validated &&
                _emailError == null &&
                _emailController.text.isNotEmpty,
          ),

          if (_step1Validated && _emailError != null)
            _buildErrorText(_emailError!),

          SizedBox(height: 20),

          // Phone Number
          _buildInputLabel('Telefon Numarası'),
          SizedBox(height: 8),

          _buildInputField(
            controller: _phoneController,
            hintText: '+90 555 123 45 67',
            keyboardType: TextInputType.phone,
            hasError: _step1Validated && _phoneError != null,
            isValid:
                _step1Validated &&
                _phoneError == null &&
                _phoneController.text.isNotEmpty,
          ),

          if (_step1Validated && _phoneError != null)
            _buildErrorText(_phoneError!),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Güvenlik',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Hesabınız için güvenli bir şifre oluşturun',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 32),

          // Password
          _buildInputLabel('Şifre'),
          SizedBox(height: 8),

          _buildInputField(
            controller: _passwordController,
            hintText: 'En az 6 karakter',
            obscureText: !_isPasswordVisible,
            hasError: _step2Validated && _passwordError != null,
            isValid:
                _step2Validated &&
                _passwordError == null &&
                _passwordController.text.length >= 6,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: Color(0xFF718096),
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),

          if (_step2Validated && _passwordError != null)
            _buildErrorText(_passwordError!),

          SizedBox(height: 20),

          // Confirm Password
          _buildInputLabel('Şifre Tekrar'),
          SizedBox(height: 8),

          _buildInputField(
            controller: _confirmPasswordController,
            hintText: 'Şifrenizi tekrar girin',
            obscureText: !_isConfirmPasswordVisible,
            hasError: _step2Validated && _confirmPasswordError != null,
            isValid:
                _step2Validated &&
                _confirmPasswordError == null &&
                _confirmPasswordController.text.isNotEmpty &&
                _passwordController.text == _confirmPasswordController.text,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: Color(0xFF718096),
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),

          if (_step2Validated && _confirmPasswordError != null)
            _buildErrorText(_confirmPasswordError!),

          SizedBox(height: 24),

          // Password Requirements
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Şifre Gereksinimleri:',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12),
                _buildPasswordRequirement(
                  'En az 6 karakter',
                  _passwordController.text.length >= 6,
                ),
                _buildPasswordRequirement(
                  'En az bir harf içermeli',
                  _passwordController.text.contains(RegExp(r'[A-Za-z]')),
                ),
                _buildPasswordRequirement(
                  'Şifreler eşleşmeli',
                  _passwordController.text == _confirmPasswordController.text &&
                      _confirmPasswordController.text.isNotEmpty,
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hesap Türü',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'AKNA platformundaki rolünüzü seçin',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 32),

          // User Type Selection
          _buildInputLabel('Kullanıcı Türü'),
          SizedBox(height: 12),

          Column(
            children:
                _userTypes.map((type) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedUserType = type;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              _selectedUserType == type
                                  ? Color(0xFF3182CE).withOpacity(0.05)
                                  : Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                _selectedUserType == type
                                    ? Color(0xFF3182CE)
                                    : Color(0xFFE2E8F0),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    _selectedUserType == type
                                        ? Color(0xFF3182CE).withOpacity(0.1)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      _selectedUserType == type
                                          ? Color(0xFF3182CE).withOpacity(0.3)
                                          : Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Icon(
                                _getUserTypeIcon(type),
                                color:
                                    _selectedUserType == type
                                        ? Color(0xFF3182CE)
                                        : Color(0xFF718096),
                                size: 22,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getUserTypeTitle(type),
                                    style: TextStyle(
                                      color: Color(0xFF2D3748),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _getUserTypeDescription(type),
                                    style: TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedUserType == type)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3182CE),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),

          SizedBox(height: 32),

          // Terms and Conditions
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xFF38A169).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Color(0xFF38A169).withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.verified_user_rounded,
                    color: Color(0xFF38A169),
                    size: 24,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Kayıt olarak AKNA Kullanım Şartları ve Gizlilik Politikası\'nı kabul etmiş olursunuz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Color(0xFF2D3748),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool hasError = false,
    bool isValid = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              hasError
                  ? Color(0xFFE53E3E)
                  : isValid
                  ? Color(0xFF38A169)
                  : Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xFF718096),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isValid)
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF38A169),
                    size: 20,
                  ),
                ),
              if (hasError)
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.error_rounded,
                    color: Color(0xFFE53E3E),
                    size: 20,
                  ),
                ),
              if (suffixIcon != null) suffixIcon,
            ],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        error,
        style: TextStyle(
          color: Color(0xFFE53E3E),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isValid ? Color(0xFF38A169) : Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: isValid ? Colors.white : Color(0xFF718096),
              size: 12,
            ),
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Color(0xFF38A169) : Color(0xFF718096),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getUserTypeIcon(String type) {
    switch (type) {
      case 'Shipper':
        return Icons.business_rounded;
      case 'Carrier':
        return Icons.local_shipping_rounded;
      case 'Driver':
        return Icons.person_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  String _getUserTypeTitle(String type) {
    switch (type) {
      case 'Shipper':
        return 'Yük Sahibi (Shipper)';
      case 'Carrier':
        return 'Taşıyıcı (Carrier)';
      case 'Driver':
        return 'Sürücü (Driver)';
      default:
        return type;
    }
  }

  String _getUserTypeDescription(String type) {
    switch (type) {
      case 'Shipper':
        return 'Yük göndermek isteyen şirket veya kişi';
      case 'Carrier':
        return 'Nakliye hizmeti veren taşıma şirketi';
      case 'Driver':
        return 'Araç kullanan sürücü';
      default:
        return '';
    }
  }
}
