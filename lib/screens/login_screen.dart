import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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

  void _goToHomeScreen() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
  }

  // obsrecure password
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login(String email, String password) async {
    try {
      Response response = await post(
          Uri.parse('https://mas-pos.appmedia.id/api/v1/login'),
          body: {
            'email': email,
            'password': password,
          });

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());
        print('Response data: $responseData');

        var token = responseData['data'];
        print('Token: $token');

        if (token != null) {
          _goToHomeScreen();
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    Center(
                      // widget gambar
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: const FlutterLogo(
                          size: 200,
                        ),
                      ),
                    ),
                    // widget container untuk membungkus widget text "Login"
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        "Login",
                        style:
                            TextStyle(fontFamily: 'ConcertOne', fontSize: 30),
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
                                hintText: "Email ID",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
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
                                hintText: "password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: _toggleObscureText,
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "Please enter your password"
                                  : null,
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
                                    emailController.text, passController.text),
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
      ),
    );
  }
}
