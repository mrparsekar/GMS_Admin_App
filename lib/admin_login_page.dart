import 'package:flutter/material.dart';
import 'dart:math';

import 'admin_home_page.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String adminUsername = "admin";
  final String adminPassword = "admin123";

  bool _isLoading = false;
  bool _isLoginSuccessful = false;

  // Animations
  late AnimationController _timerController;
  late AnimationController _buttonController;
  late Animation<Offset> _successAnimation;

  @override
  void initState() {
    super.initState();

    // Timer spinning animation
    _timerController = AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..repeat();

    // Button bounce animation
    _buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Success message slide-in animation
    _successAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _timerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _isLoginSuccessful = false;
    });

    // Simulate a network delay
    await Future.delayed(Duration(seconds: 2));

    if (_usernameController.text == adminUsername && _passwordController.text == adminPassword) {
      setState(() {
        _isLoginSuccessful = true;
      });
      await Future.delayed(Duration(seconds: 1)); // Short delay before navigation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/admin_background.jpg'), // Ensure this image is in your assets folder
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay to darken the background
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  ClipOval(
                    child: Image.asset(
                      "assets/app_icon/GYM FREAK Logo.png",  // Path to your logo image
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,  // Ensures the image fills the circular area
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to Gym Management\nAdmin Portal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Login form card
                  Card(
                    color: Colors.white.withOpacity(0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Username field
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.black87),
                              prefixIcon: Icon(Icons.person, color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          SizedBox(height: 15),
                          // Password field
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black87),
                              prefixIcon: Icon(Icons.lock, color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Bouncing Login button
                          ScaleTransition(
                            scale: Tween(begin: 1.0, end: 1.1).animate(_buttonController),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _login,
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Stopwatch Loader
                  if (_isLoading)
                    AnimatedBuilder(
                      animation: _timerController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _timerController.value * 2 * pi,
                          child: Icon(
                            Icons.timer,
                            color: Colors.tealAccent,
                            size: 50,
                          ),
                        );
                      },
                    ),

                  // Slide-in Success message with muscle emoji
                  if (_isLoginSuccessful)
                    SlideTransition(
                      position: _successAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 60,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Success! 💪',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
