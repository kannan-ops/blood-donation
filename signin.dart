import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isButtonEnabled = false;

  final List<String> genders = ["Male", "Female", "Others"];
  String? gender;

  final TextEditingController name = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();

  void _checkFields() {
    setState(() {
      _isButtonEnabled = name.text.isNotEmpty &&
          phonenumber.text.isNotEmpty &&
          password.text.isNotEmpty &&
          email.text.isNotEmpty &&
          gender != null;
    });
  }

  Future<void> createUser() async {
    try {
      var bodyData = {
        "username": name.text.trim(),
        "phoneno": phonenumber.text.trim(),
        "password": password.text.trim(),
        "email": email.text.trim(),
        "gender": gender,
      };

      var res = await http.post(
        Uri.parse("https://kannan-blood-donation.onrender.com/user/create-user"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: ${res.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
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
              boxShadow:  [
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:  LinearGradient(
                        colors: [Colors.redAccent, Colors.deepOrange],
                      ),
                      boxShadow:  [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child:  Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                 SizedBox(height: 15),
                buildAnimatedField(
                  delay: 150,
                  child:  Text(
                    "PulseCare Signup",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                 SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      buildAnimatedField(
                        delay: 250,
                        child: TextFormField(
                          controller: name,
                          onChanged: (_) => _checkFields(),
                          style:  TextStyle(color: Colors.white),
                          decoration: _inputDecoration("Name", Icons.person),
                          validator: (value) => value == null || value.isEmpty ? "Enter your name" : null,
                        ),
                      ),
                       SizedBox(height: 15),


                      buildAnimatedField(
                        delay: 350,
                        child: TextFormField(
                          controller: phonenumber,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => _checkFields(),
                          style:  TextStyle(color: Colors.white),
                          decoration: _inputDecoration("Phone Number", Icons.phone),
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Enter phone number";
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) return "Enter valid 10-digit number";
                            return null;
                          },
                        ),
                      ),
                       SizedBox(height: 15),


                      buildAnimatedField(
                        delay: 450,
                        child: TextFormField(
                          controller: password,
                          onChanged: (_) => _checkFields(),
                          obscureText: !_isPasswordVisible,
                          style:  TextStyle(color: Colors.white),
                          decoration: _inputDecoration("Password", Icons.lock).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (input) {
                            if (input == null || input.isEmpty) return "Enter password";
                            if (input.length < 6) return "Password must be at least 6 characters";
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),


                      buildAnimatedField(
                        delay: 550,
                        child: TextFormField(
                          controller: email,
                          onChanged: (_) => _checkFields(),
                          style:  TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration("Email", Icons.email),
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Enter email";
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Enter valid email";
                            return null;
                          },
                        ),
                      ),
                       SizedBox(height: 15),


                      buildAnimatedField(
                        delay: 650,
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.grey[850],
                          value: gender,
                          style:  TextStyle(color: Colors.white),
                          hint:  Text("Select Gender", style: TextStyle(color: Colors.white70)),
                          items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(color: Colors.white)))).toList(),
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                              _checkFields();
                            });
                          },
                          decoration: _inputDecoration("Gender", Icons.transgender),
                          validator: (value) => value == null ? "Select gender" : null,
                        ),
                      ),
                       SizedBox(height: 25),


                      buildAnimatedField(
                        delay: 750,
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              elevation: 5,
                            ),
                            onPressed: _isButtonEnabled
                                ? () {
                              if (_formKey.currentState!.validate()) {
                                createUser();
                              }
                            }
                                : null,
                            child:  Text("Submit", style: TextStyle(fontSize: 20)),
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

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle:  TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.redAccent),
      filled: true,
      fillColor: Colors.grey[850],
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide:  BorderSide(color: Colors.white38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide:  BorderSide(color: Colors.redAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide:  BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide:  BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}
