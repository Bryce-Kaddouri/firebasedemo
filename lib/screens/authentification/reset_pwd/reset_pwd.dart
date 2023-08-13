import 'package:firebasedemo/services/auth_service.dart';
import 'package:flutter/material.dart';

class ResetPwdScreen extends StatefulWidget {
  const ResetPwdScreen({super.key});

  @override
  State<ResetPwdScreen> createState() => _ResetPwdScreenState();
}

class _ResetPwdScreenState extends State<ResetPwdScreen> {
  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the email field
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ResetPwd'),
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
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // do something
                  AuthService.resetPassword(_emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reset password email sent'),
                    ),
                  );

                }
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
