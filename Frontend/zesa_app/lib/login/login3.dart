import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:WattTrade/components/themes.dart';
import 'package:WattTrade/screens/prosumer/landing.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  late AnimationController _buttonController;

  @override
  void initState(){
    super.initState();
    _loadAnimations();
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _loadAnimations(){
    _buttonController = AnimationController(
      duration: const Duration(microseconds: 150),
      vsync: this,
    );
  }

  void _toggleLoginSignup(){
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Button press animation
      _buttonController.forward().then((_) {
        _buttonController.reverse();
      });
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        _showSuccessMessage(_isLogin ? 'Welcome back!' : 'Account created successfully!');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingPage(userRole: "Prosumer",)));
      }
    }
  }

    Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        validator: validator,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(icon, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    size: 20,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2.5),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildAuthToggle() {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark 
          ? const Color.fromARGB(255, 51, 64, 87).withOpacity(0.5)
          : const Color.fromARGB(255, 229, 233, 235),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _isLogin ? null : _toggleLoginSignup,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: _isLogin
                    ? LinearGradient(
                        colors: isDark
                          ? [
                              const Color(0xFF4A5568),
                              const Color(0xFF2D3748),
                            ]
                          : [
                              const Color.fromARGB(255, 193, 193, 197),
                              const Color.fromARGB(255, 59, 59, 59),
                            ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                  color: !_isLogin ? Colors.transparent : null,
                ),
                child: Text(
                  'Log In',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: _isLogin ? FontWeight.w600 : FontWeight.w400,
                    color: _isLogin 
                      ? Colors.black 
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: !_isLogin ? null : _toggleLoginSignup,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: !_isLogin
                    ? LinearGradient(
                        colors: isDark
                          ? [
                              const Color(0xFF4A5568),
                              const Color(0xFF2D3748),
                            ]
                          : [
                              const Color.fromARGB(255, 193, 193, 197),
                              const Color.fromARGB(255, 59, 59, 59),
                            ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                  color: _isLogin ? Colors.transparent : null,
                ),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: !_isLogin ? FontWeight.w600 : FontWeight.w400,
                    color: !_isLogin 
                      ? Colors.white 
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            if (!_isLogin) ...[
              _buildInputField(
                label: 'Full Name',
                controller: _nameController,
                icon: Icons.person_outline_rounded,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
            ],
            _buildInputField(
              label: 'Email Address',
              controller: _emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email address';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            _buildInputField(
              label: 'Password',
              controller: _passwordController,
              icon: Icons.lock_outline_rounded,
              isPassword: true,
              isPasswordVisible: _isPasswordVisible,
              toggleVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                if (!_isLogin && !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                  return 'Password must include uppercase, lowercase, and numbers';
                }
                return null;
              },
            ),
            if (!_isLogin) ...[
              _buildInputField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                isPasswordVisible: _isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 8),
            _buildPrimaryButton(
              _isLogin ? 'Log In' : 'Create Account',
            _handleSubmit,
            ),
            const SizedBox(height: 16),
            if (_isLogin) ...[
              Center(
                child: TextButton(
                  onPressed: (){},
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ]
          ],
        ),
      ),
    );
  }
Widget _buildPrimaryButton(String text, VoidCallback? onPressed) {
  return AnimatedBuilder(
    animation: _buttonController,
    builder: (context, child) {
      final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
      
      return Transform.scale(
        scale: 1.0 - (_buttonController.value * 0.03),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: isDark
                ? [
                    const Color(0xFF4A5568), // darker gray-blue for dark mode
                    const Color(0xFF2D3748),
                  ]
                : [
                    const Color.fromARGB(255, 193, 193, 197),
                    const Color.fromARGB(255, 59, 59, 59),
                  ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark 
                  ? Colors.black.withOpacity(0.3)
                  : const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                Provider.of<ThemeProvider>(context).isDarkMode
                  ? 'assets/nightLights.jpg'
                  : 'assets/sunShare.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // 
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.8,
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: Provider.of<ThemeProvider>(context).isDarkMode
                    //     ? [
                    //         const Color.fromARGB(127, 60, 60, 80),   
                    //         const Color.fromARGB(200, 31, 184, 39),   
                    //       ]
                    //     : [
                    //         const Color.fromARGB(125, 134, 128, 170), 
                    //         const Color.fromARGB(200, 31, 184, 39),     
                    //       ],
                    // ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5)
                      )
                    ]
                  ),
                  child:Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Watt',
                            style: GoogleFonts.zenDots(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                            }, 
                            icon: Icon(
                              Provider.of<ThemeProvider>(context).isDarkMode
                                ? Icons.flash_on
                                : Icons.electric_bolt
                            ), 
                            color: Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.black
                              : Colors.white,
                            highlightColor: Colors.transparent,
                            iconSize: 38,
                          ),
                          Text(
                            'Trade',
                            style: GoogleFonts.zenDots(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Neighbors Powering Neighbourhoods',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                
                      //padding based on whether its login or signup
                      if(_isLogin == true)
                      SizedBox(height: screenHeight * 0.05,),
                      // const Spacer(),

                      // container will both login and signup logic
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent
                          ),
                          width: double.infinity,
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: screenHeight * .8
                              ),
                              child: Card(
                                elevation: 24,
                                shadowColor: Colors.black.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildAuthToggle(),
                                        SizedBox(height: 10),
                                        AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 350),
                                          transitionBuilder: (child, animation) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(0.0, 0.1),
                                                  end: Offset.zero,
                                                ).animate(CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeOutCubic,
                                                )),
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            // color: Provider.of<ThemeProvider>(context).isDarkMode
                                            //   ? Colors.black.withOpacity(0.7)
                                            //   : Colors.white.withOpacity(0.7),
                                            key: ValueKey(_isLogin),
                                            child: _buildAuthForm(),
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
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}