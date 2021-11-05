import 'dart:io';

import 'package:auction_app1/picker/user_image_picker.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;
  var submitFn;
  void function(
    String email,
    String password,
    String userName,
    File? image,
    bool isLogin,
    BuildContext ctx,
  );

  @override
  _AuthFormState createState() => _AuthFormState();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPasssword = '';
  File? _userImageFile;

  void pickedImage(File? image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Pick an Image..'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState?.save();
      print(_userEmail);
      print(_userName);
      print(_userPasssword);
      print(' Good to go ');
      widget.submitFn(
        _userEmail.trim(),
        _userPasssword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    } else {
      print('Form is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isLogin) UserImagePicker(pickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty ||
                        !value.contains(RegExp(
                            '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]+.[com]'))) {
                      return 'enter valid Email';
                      //print('Email validation is not ok');
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email Address', icon: Icon(Icons.email)),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('userName'),
                    onSaved: (value) {
                      _userName = value!;
                    },
                    validator: (value) {
                      if (value == null || value.length < 4) {
                        return 'Enter At least 4 charaters ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'User Name', icon: Icon(Icons.person)),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  onSaved: (value) {
                    _userPasssword = value!;
                  },
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 7) {
                      return 'Enter at least 7 Digits';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(
                      Icons.security,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                    onPressed: _trySubmit,
                  ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    child: Text(_isLogin
                        ? 'Create New Account'
                        : 'I already have an account'),
                    onPressed: () {
                      setState(
                        () {
                          _isLogin = !_isLogin;
                        },
                      );
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
