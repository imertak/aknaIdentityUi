import 'package:akna_ui/emailVerificationScreen.dart';
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
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black,
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
      backgroundColor: Colors.black,
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

                  // Animated Logo ve araç görseli
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFCEFF00),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          color: Color(0xFFCEFF00),
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
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
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
                            color: Color(0xFFCEFF00).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color(0xFFCEFF00).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Türkiye\'nin Freight Platformu',
                            style: TextStyle(
                              color: Color(0xFFCEFF00),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        Text(
                          '🚛 Yük Taşımacılığında Yeni Dönem\n📱 Hızlı • Güvenli • Ekonomik',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
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
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900]!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[800]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("1000+", "Aktif Sürücü"),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey[700],
                          ),
                          _buildStatItem("50+", "Şehir"),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey[700],
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
                          backgroundColor: Color(0xFFCEFF00),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          shadowColor: Color(0xFFCEFF00).withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Başlayalım',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
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
                            Icons.verified_user,
                            'GÜVENLİ &\nSertifikalı',
                            'SSL şifreleme\nve güvenli ödeme',
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildFeatureCard(
                            Icons.speed,
                            'HIZLI\nTeslim',
                            'Anlık takip\nve bildirimler',
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildFeatureCard(
                            Icons.attach_money,
                            'EKONOMİK\nFiyatlar',
                            'En uygun\nnakliye ücretleri',
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
            color: Color(0xFFCEFF00),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(0xFFCEFF00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFFCEFF00), size: 16),
          ),
          SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 7),
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

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
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
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 40),

              // Email Field
              Text(
                'E-posta',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
              SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'ornek@akna.com',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Password Field
              Text(
                'Şifre',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
              SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '••••••••••••',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
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
                              Tween(begin: Offset(1.0, 0.0), end: Offset.zero),
                            ),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Şifremi Unuttum?',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ),
              ),

              SizedBox(height: 32),

              // Login Button
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Login logic here
                    print('Login: ${_emailController.text}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCEFF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Giriş Yap',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              Spacer(),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hesabın yok mu? ',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
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
                        color: Color(0xFFCEFF00),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.black),
            SizedBox(width: 8),
            Expanded(
              child: Text(message, style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        backgroundColor: Color(0xFFCEFF00),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kayıt Ol ${_currentStep + 1}/3',
          style: TextStyle(color: Colors.white, fontSize: 18),
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
                                ? Color(0xFFCEFF00)
                                : Colors.grey[700],
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
                        height: 50,
                        margin: EdgeInsets.only(right: 12),
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xFFCEFF00)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Geri',
                            style: TextStyle(
                              color: Color(0xFFCEFF00),
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
                      height: 50,
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
                          backgroundColor: Color(0xFFCEFF00),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentStep == 2 ? 'Kayıt Ol' : 'Devam Et',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Hesabınızı oluşturmak için kişisel bilgilerinizi girin',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),

          SizedBox(height: 32),

          // First Name
          Text('Ad', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border:
                  _step1Validated && _firstNameError != null
                      ? Border.all(color: Colors.red, width: 1)
                      : null,
            ),
            child: TextField(
              controller: _firstNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Adınız',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon:
                    _step1Validated &&
                            _firstNameError == null &&
                            _firstNameController.text.isNotEmpty
                        ? Icon(
                          Icons.check_circle,
                          color: Color(0xFFCEFF00),
                          size: 20,
                        )
                        : _step1Validated && _firstNameError != null
                        ? Icon(Icons.error, color: Colors.red, size: 20)
                        : null,
              ),
            ),
          ),

          if (_step1Validated && _firstNameError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                _firstNameError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          SizedBox(height: 20),

          // Last Name
          Text(
            'Soyad',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border:
                  _step1Validated && _lastNameError != null
                      ? Border.all(color: Colors.red, width: 1)
                      : null,
            ),
            child: TextField(
              controller: _lastNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Soyadınız',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon:
                    _step1Validated &&
                            _lastNameError == null &&
                            _lastNameController.text.isNotEmpty
                        ? Icon(
                          Icons.check_circle,
                          color: Color(0xFFCEFF00),
                          size: 20,
                        )
                        : _step1Validated && _lastNameError != null
                        ? Icon(Icons.error, color: Colors.red, size: 20)
                        : null,
              ),
            ),
          ),

          if (_step1Validated && _lastNameError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                _lastNameError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          SizedBox(height: 20),

          // Email
          Text(
            'E-posta',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border:
                  _step1Validated && _emailError != null
                      ? Border.all(color: Colors.red, width: 1)
                      : null,
            ),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'ornek@akna.com',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon:
                    _step1Validated &&
                            _emailError == null &&
                            _emailController.text.isNotEmpty
                        ? Icon(
                          Icons.check_circle,
                          color: Color(0xFFCEFF00),
                          size: 20,
                        )
                        : _step1Validated && _emailError != null
                        ? Icon(Icons.error, color: Colors.red, size: 20)
                        : null,
              ),
            ),
          ),

          if (_step1Validated && _emailError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                _emailError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          SizedBox(height: 20),

          // Phone Number
          Text(
            'Telefon Numarası',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border:
                  _step1Validated && _phoneError != null
                      ? Border.all(color: Colors.red, width: 1)
                      : null,
            ),
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '+90 555 123 45 67',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon:
                    _step1Validated &&
                            _phoneError == null &&
                            _phoneController.text.isNotEmpty
                        ? Icon(
                          Icons.check_circle,
                          color: Color(0xFFCEFF00),
                          size: 20,
                        )
                        : _step1Validated && _phoneError != null
                        ? Icon(Icons.error, color: Colors.red, size: 20)
                        : null,
              ),
            ),
          ),

          if (_step1Validated && _phoneError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                _phoneError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

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
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Hesabınız için güvenli bir şifre oluşturun',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),

          SizedBox(height: 32),

          // Password
          Text(
            'Şifre',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border:
                  _step2Validated && _passwordError != null
                      ? Border.all(color: Colors.red, width: 1)
                      : null,
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'En az 6 karakter',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_step2Validated &&
                        _passwordError == null &&
                        _passwordController.text.length >= 6)
                      Icon(
                        Icons.check_circle,
                        color: Color(0xFFCEFF00),
                        size: 20,
                      ),
                    if (_step2Validated && _passwordError != null)
                      Icon(Icons.error, color: Colors.red, size: 20),
                    IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_step2Validated && _passwordError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                _passwordError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          SizedBox(height: 20),

          // Confirm Password
          Text(
            'Şifre Tekrar',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border:
                  _step2Validated && _confirmPasswordError != null
                      ? Border.all(color: Colors.red, width: 1)
                      : null,
            ),
            child: TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Şifrenizi tekrar girin',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_step2Validated &&
                        _confirmPasswordError == null &&
                        _confirmPasswordController.text.isNotEmpty &&
                        _passwordController.text ==
                            _confirmPasswordController.text)
                      Icon(
                        Icons.check_circle,
                        color: Color(0xFFCEFF00),
                        size: 20,
                      ),
                    if (_step2Validated && _confirmPasswordError != null)
                      Icon(Icons.error, color: Colors.red, size: 20),
                    IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_step2Validated && _confirmPasswordError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                _confirmPasswordError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          SizedBox(height: 20),
          SizedBox(height: 16),
          // Password Requirements
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900]!.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Şifre Gereksinimleri:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
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
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'AKNA platformundaki rolünüzü seçin',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),

          SizedBox(height: 32),

          // User Type Selection
          Text(
            'Kullanıcı Türü',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
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
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              _selectedUserType == type
                                  ? Color(0xFFCEFF00).withOpacity(0.1)
                                  : Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                _selectedUserType == type
                                    ? Color(0xFFCEFF00)
                                    : Colors.grey[800]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getUserTypeIcon(type),
                              color:
                                  _selectedUserType == type
                                      ? Color(0xFFCEFF00)
                                      : Colors.grey[400],
                              size: 24,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getUserTypeTitle(type),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _getUserTypeDescription(type),
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedUserType == type)
                              Icon(
                                Icons.check_circle,
                                color: Color(0xFFCEFF00),
                                size: 24,
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900]!.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Column(
              children: [
                Icon(Icons.verified_user, color: Color(0xFFCEFF00), size: 32),
                SizedBox(height: 12),
                Text(
                  'Kayıt olarak AKNA Kullanım Şartları ve Gizlilik Politikası\'nı kabul etmiş olursunuz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? Color(0xFFCEFF00) : Colors.grey[600],
            size: 16,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Color(0xFFCEFF00) : Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getUserTypeIcon(String type) {
    switch (type) {
      case 'Shipper':
        return Icons.business;
      case 'Carrier':
        return Icons.local_shipping;
      case 'Driver':
        return Icons.person;
      default:
        return Icons.person;
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

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Title
              Text(
                'Şifremi Unuttum',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16),

              Text(
                'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),

              SizedBox(height: 40),

              // Email Field
              Text(
                'E-posta',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
              SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'ornek@akna.com',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32),

              // Send Reset Link Button
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Send reset link logic here
                    print('Send reset link to: ${_emailController.text}');
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Şifre sıfırlama bağlantısı gönderildi!'),
                        backgroundColor: Color(0xFFCEFF00),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCEFF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Sıfırlama Bağlantısı Gönder',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              Spacer(),

              // Back to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Şifreni hatırladın mı? ',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Giriş Yap',
                      style: TextStyle(
                        color: Color(0xFFCEFF00),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
    );
  }
}
