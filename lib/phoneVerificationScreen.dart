import 'package:flutter/material.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;

  PhoneVerificationScreen({required this.phoneNumber, required this.email});

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen>
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

  String _formatPhoneNumber(String phone) {
    // +90 555 123 45 67 formatına çevir
    if (phone.length >= 10) {
      return '+90 ${phone.substring(phone.length - 10, phone.length - 7)} ${phone.substring(phone.length - 7, phone.length - 4)} ${phone.substring(phone.length - 4, phone.length - 2)} ${phone.substring(phone.length - 2)}';
    }
    return phone;
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

  void _verifyCode() {
    if (!_isCodeComplete) return;

    String code = _getVerificationCode();
    print('SMS Verification code: $code');

    // Simulated verification
    if (code == '654321') {
      _showSuccessSnackBar('Telefon numarası başarıyla doğrulandı!');

      // Ana sayfa veya dashboard'a yönlendir
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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

    _showSuccessSnackBar('SMS doğrulama kodu tekrar gönderildi!');
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
          'Telefon Doğrulama',
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

                // Animated Phone Icon
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
                        Icons.phone_android,
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
                    'Telefon Doğrulama',
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
                        'Telefon numaranıza 6 haneli SMS kodu gönderdik:',
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
                              Icons.phone,
                              color: Color(0xFFCEFF00),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              _formatPhoneNumber(widget.phoneNumber),
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

                // Progress Indicators
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900]!.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: Row(
                      children: [
                        // Email step
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Color(0xFFCEFF00),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'E-posta\nDoğrulandı',
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

                        // Separator
                        Container(
                          width: 30,
                          height: 2,
                          color: Color(0xFFCEFF00),
                        ),

                        // Phone step
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Color(0xFFCEFF00),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                  size: 14,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Telefon\nDoğrulama',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Verification Code Input
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'SMS Kodunu Girin',
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
                                  ? 'SMS tekrar gönderilebilir'
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
                                          Icon(Icons.sms, size: 18),
                                          SizedBox(width: 6),
                                          Text(
                                            'SMS\'i Tekrar Gönder',
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
                                ? 'Telefonu Doğrula'
                                : 'SMS Kodunu Girin (6 hane)',
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
                          'SMS kodunu alamadınız mı? Telefon numaranızı kontrol edin ve "SMS\'i Tekrar Gönder" butonunu kullanın.',
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
                            '📱 Test SMS kodu: 654321',
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
