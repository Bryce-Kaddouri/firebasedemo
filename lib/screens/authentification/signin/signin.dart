import 'package:firebasedemo/screens/authentification/reset_pwd/reset_pwd.dart';
import 'package:firebasedemo/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../signup/signup.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the email field
  final _emailController = TextEditingController();
  // controller for the password field
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signin'),
      ),
      body:
      Container(
        margin: EdgeInsets.all(20),
        child:
      Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }else if (!value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => ResetPwdScreen()),
                 );
              },
              child: Text('Forgot Password?'),
            ),
            SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => SignupScreen()),
                 );
              },
              child: Text('Create an account'),
            ),


            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  AuthService.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                  setState(() {

                  });
                }
              },
              child: const Text('Signin'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
