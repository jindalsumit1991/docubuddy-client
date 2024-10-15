import 'package:flutter/material.dart';
import 'package:image_uploader/services/auth_service.dart';
import 'package:image_uploader/utils/docu_colors.dart';
import 'package:image_uploader/views/pages/home_view.dart';
import 'package:image_uploader/views/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _errorMessage = '';

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      await _authService.signInUser(
          _emailController.text, _passwordController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeView()));
    } catch (e) {
      setState(() {
        _errorMessage = "Invalid User ID or password. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo or branding
              Image.asset('assets/logo-brain.png', height: 100),
              const SizedBox(height: 30),

              // Login Form in a card
              Card(
                elevation: 15,
                color: DocuColors.geyser,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Email TextField
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'User ID',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password TextField with toggle visibility
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Enhanced Error Message Display
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _errorMessage,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
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
              ),

              const SizedBox(height: 20),

              // Login Button with loading spinner
              _isLoading
                  ? const CircularProgressIndicator()
                  : _buildUploadButton(),

              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return CustomButton(
      onPressed: _login,
      label: 'Login',
      backgroundColor: DocuColors.blue_dianne,
    );
  }
}
