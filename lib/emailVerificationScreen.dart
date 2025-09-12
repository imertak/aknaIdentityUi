import 'package:akna_ui/phoneVerificationScreen.dart';
import 'package:flutter/material.dart';

// PhoneVerificationScreen'i import et
// import 'phone_verification_screen.dart'; // Bu satırı kendi dosya yapınıza göre ayarlayın

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String phoneNumber;

  EmailVerificationScreen({required this.email, this.phoneNumber = ''});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  int _timeLeft = 300; // 5 dakika = 300 saniye
  bool _isCodeComplete = false;
  bool _isResending = false;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _fadeController.forward();

    _startCountdown();

    // İlk input'a focusla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && _timeLeft > 0) {
        setState(() {
          _timeLeft--;
          if (_timeLeft == 0) {
            _canResend = true;
          }
        });
        _startCountdown();
      }
    });
  }

  String _getFormattedTime() {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onCodeChanged(String value, int index) {
    setState(() {
      if (value.length == 1 && index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else if (value.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }

      // Kodun tamamlanıp tamamlanmadığını kontrol et
      _isCodeComplete = _codeControllers.every(
        (controller) => controller.text.length == 1,
      );
    });
  }

  String _getVerificationCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  void navigateToPhoneVerification(
    BuildContext context,
    String email,
    String phoneNumber,
  ) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                PhoneVerificationScreen(email: email, phoneNumber: phoneNumber),
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

  void _verifyCode() {
    if (!_isCodeComplete) return;

    String code = _getVerificationCode();
    print('Verification code: $code');

    // Simulated verification
    if (code == '123456') {
      _showSuccessSnackBar('E-posta başarıyla doğrulandı!');

      // Telefon doğrulama sayfasına yönlendir
      navigateToPhoneVerification(context, widget.email, widget.phoneNumber);
    } else {
      _showErrorSnackBar('Geçersiz doğrulama kodu. Lütfen tekrar deneyin.');
      _clearCode();
    }
  }

  void _clearCode() {
    setState(() {
      for (var controller in _codeControllers) {
        controller.clear();
      }
      _isCodeComplete = false;
    });
    _focusNodes[0].requestFocus();
  }

  void _resendCode() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isResending = false;
      _canResend = false;
      _timeLeft = 300; // Reset timer
    });

    _showSuccessSnackBar('Doğrulama kodu tekrar gönderildi!');
    _startCountdown();
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
          'E-posta Doğrulama',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  kToolbarHeight -
                  48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),

                // Animated Email Icon
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFFCEFF00).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFCEFF00), width: 2),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        color: Color(0xFFCEFF00),
                        size: 40,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Hesabınızı Doğrulayın',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Description
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'E-posta adresinize 6 haneli doğrulama kodu gönderdik:',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xFFCEFF00).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.email,
                              color: Color(0xFFCEFF00),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              widget.email,
                              style: TextStyle(
                                color: Color(0xFFCEFF00),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Verification Code Input
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Doğrulama Kodunu Girin',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 42,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    _focusNodes[index].hasFocus
                                        ? Color(0xFFCEFF00)
                                        : _codeControllers[index]
                                            .text
                                            .isNotEmpty
                                        ? Color(0xFFCEFF00).withOpacity(0.5)
                                        : Colors.grey[700]!,
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              controller: _codeControllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged:
                                  (value) => _onCodeChanged(value, index),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Timer and Resend
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900]!.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _canResend ? Icons.refresh : Icons.timer,
                              color:
                                  _canResend
                                      ? Color(0xFFCEFF00)
                                      : Colors.grey[400],
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              _canResend
                                  ? 'Kod tekrar gönderilebilir'
                                  : 'Kalan süre: ${_getFormattedTime()}',
                              style: TextStyle(
                                color:
                                    _canResend
                                        ? Color(0xFFCEFF00)
                                        : Colors.grey[400],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (_canResend) ...[
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: OutlinedButton(
                              onPressed: _isResending ? null : _resendCode,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0xFFCEFF00)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child:
                                  _isResending
                                      ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color(0xFFCEFF00),
                                                  ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Gönderiliyor...',
                                            style: TextStyle(
                                              color: Color(0xFFCEFF00),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.refresh, size: 18),
                                          SizedBox(width: 6),
                                          Text(
                                            'Kodu Tekrar Gönder',
                                            style: TextStyle(
                                              color: Color(0xFFCEFF00),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Verify Button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isCodeComplete ? _verifyCode : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isCodeComplete
                                ? Color(0xFFCEFF00)
                                : Colors.grey[700],
                        foregroundColor:
                            _isCodeComplete ? Colors.black : Colors.grey[500],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isCodeComplete) ...[
                            Icon(Icons.verified_user, size: 20),
                            SizedBox(width: 8),
                          ],
                          Text(
                            _isCodeComplete
                                ? 'Hesabı Doğrula'
                                : 'Kodu Girin (6 hane)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Flexible spacer
                SizedBox(height: 20),

                // Help Text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900]!.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.help_outline,
                              color: Color(0xFFCEFF00),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Yardım',
                              style: TextStyle(
                                color: Color(0xFFCEFF00),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Kodu alamadınız mı? Spam/Junk klasörünüzü kontrol edin. Hala bulamıyorsanız "Kodu Tekrar Gönder" butonunu kullanın.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFCEFF00).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0xFFCEFF00).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '💡 Test kodu: 123456',
                            style: TextStyle(
                              color: Color(0xFFCEFF00),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
