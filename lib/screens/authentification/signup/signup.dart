import 'package:firebasedemo/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the email field
  final _emailController = TextEditingController();
  // controller for the password field
  final _passwordController = TextEditingController();
  // controller for the confirm password field
  final _confirmPasswordController = TextEditingController();
  // controller for the role field
  final _roleController = TextEditingController();
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    _roleController.text = 'user';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
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
            SizedBox(height: 20,),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your confirm password';
                }else if (value != _passwordController.text) {
                  return 'Confirm password is not match';
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            // drom down button to select the user type
            DropdownButtonFormField(
              value: _roleController.text,
              decoration: InputDecoration(
                labelText: 'User Type',
              ),
              items: [
                DropdownMenuItem(
                  child: Text('User'),
                  value: 'user',
                ),
                DropdownMenuItem(
                  child: Text('Admin'),
                  value: 'admin',
                ),
              ],
              onChanged: (value) {
                print(value);
                _roleController.text = value.toString();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your user type';
                }
                return null;
              },
            ),
            SizedBox(height: 20,),

            isLoading ? CircularProgressIndicator() :
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  AuthService.signUpWithEmailAndPassword(
                _emailController.text,
                  _passwordController.text,
                  _roleController.text,
                  ).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Signup successfully'),
                      ),
                    );
                  }).catchError(
                    (error) {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );


                  }
                  );
                }
              }, child: Text('Signup'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
