import 'dart:convert';
import 'package:blooddonation/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false; // 👈 loading indicator flag

  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _checkFields() {
    setState(() {
      _isButtonEnabled = _phonenumberController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _login(String phno, String passwrd) async {
    setState(() {
      _isLoading = true; // 👈 start loading
    });

    try {
      final bodyData = {"phoneno": phno.trim(), "password": passwrd.trim()};

      final response = await http.post(
        Uri.parse("https://kannan-blood-donation.onrender.com/user/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        if (res["status"] == true) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', res["user"]["_id"]);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Successful"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid Phone Number or Password"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // 👈 stop loading
      });
    }
  }

  Widget buildAnimatedField({required Widget child, required int delay}) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOut,
      builder: (context, Offset offset, _) {
        return Transform.translate(
          offset: offset * 50,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1.0,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withOpacity(0.95),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 25,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildAnimatedField(
                  delay: 50,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.redAccent, Colors.deepOrange],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                buildAnimatedField(
                  delay: 150,
                  child: const Text(
                    "PulseCare",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildAnimatedField(
                        delay: 250,
                        child: TextFormField(
                          controller: _phonenumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            prefixIcon:
                            const Icon(Icons.phone, color: Colors.redAccent),
                            filled: true,
                            fillColor: Colors.grey[850],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (input) =>
                          input == null || input.isEmpty
                              ? "Enter phone number"
                              : null,
                          onChanged: (_) => _checkFields(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildAnimatedField(
                        delay: 350,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon:
                            const Icon(Icons.lock, color: Colors.redAccent),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[850],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (input) =>
                          input == null || input.isEmpty
                              ? "Enter password"
                              : null,
                          onChanged: (_) => _checkFields(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      buildAnimatedField(
                        delay: 450,
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 5,
                            ),
                            onPressed: _isButtonEnabled && !_isLoading
                                ? () {
                              if (_formKey.currentState!.validate()) {
                                _login(
                                  _phonenumberController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                              }
                            }
                                : null,
                            child: _isLoading
                                ? const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                                : const Text(
                              "Login",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      buildAnimatedField(
                        delay: 550,
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.redAccent,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup()),
                              );
                            },
                            child: const Text(
                              "Go to Signin",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.redAccent,
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
        ),
      ),
    );
  }
}
