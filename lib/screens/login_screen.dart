import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/wave_bg.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void _goToHomeScreen(String token) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            token: token,
          ),
        ));
  }

  void _popUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gagal masuk'),
        content:
            const Text('Maaf, Email atau kata sandi salah. Silakan coba lagi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // obsrecure password
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login(String email, String password) async {
    try {
      var response = await http
          .post(Uri.parse('https://mas-pos.appmedia.id/api/v1/login'), body: {

        'email': emailController.text,
        'password': passController.text,
      });

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());

        var token = responseData['data']['token'];
        if (token != null) {
          _goToHomeScreen(token);
        }
      } else if (response.statusCode == 400) {
        _popUpDialog();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          const WaveBackground(),
          ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      key: _formKey,
                      child: Column(
                        children: [
                          // EMAIL
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10),
                              prefixIcon: Icon(Icons.alternate_email_rounded),
                              labelText: "Email",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Masukkan alamat email";
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 20),
                          // PASSWORD
                          TextFormField(
                            controller: passController,
                            keyboardType: TextInputType.text,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsetsDirectional.symmetric(
                                      horizontal: 10),
                              prefixIcon: const Icon(Icons.lock),
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: _toggleObscureText,
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Masukkan kata sandi" : null,
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Theme.of(context).primaryColor),
                              ),
                              onPressed: () => _login(
                                emailController.text,
                                passController.text,
                              ),
                              child: const Text(
                                "Masuk",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
