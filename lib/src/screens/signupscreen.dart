import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kamispa/src/blocs/account_bloc.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  Account_Bloc _account_bloc = Account_Bloc();

  _onClickeDangKy() async {
    if (_account_bloc.isValidSingUp(_emailController.text.trim(),
        _passwordController.text.trim(), _nameController.text.trim())) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      await usersCollection.doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        // Các trường khác mà bạn muốn lưu trong Firestore
      });
      await userCredential.user!.updateDisplayName(_nameController.text.trim());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đăng ký thành công'),
            content: Text('Quay trở lại và đăng nhập ngay nào'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đăng ký thất bại'),
            content: Text('Đã có lỗi xảy ra. Vui lòng thử lại sau'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.cyanAccent,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 150, 0, 20),
                  child: Container(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: StreamBuilder(
                      stream: _account_bloc.emailStream,
                      builder: (context, snapshot) => TextField(
                            controller: _emailController,
                            onTap: () {},
                            style: TextStyle(),
                            decoration: InputDecoration(
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: StreamBuilder(
                      stream: _account_bloc.tenTaiKhoanStream,
                      builder: (context, snapshot) => TextField(
                            controller: _nameController,
                            onTap: () {},
                            style: TextStyle(),
                            decoration: InputDecoration(
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: StreamBuilder(
                      stream: _account_bloc.matKhauStream,
                      builder: (context, snapshot) => TextField(
                            controller: _passwordController,
                            style: TextStyle(),
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                suffixIconColor: Colors.black54,
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
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          )),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          _onClickeDangKy();
                        },
                      ),
                    )),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: Colors.pink),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
