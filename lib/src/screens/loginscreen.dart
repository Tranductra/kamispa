import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kamispa/src/screens/forgotpasswordscreen.dart';
import 'package:kamispa/src/screens/signupscreen.dart';
import 'package:provider/provider.dart';

import '../blocs/account_bloc.dart';
import '../class/UserData.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Account_Bloc _account_bloc = Account_Bloc();

  _onClickeDangNhap() async {
    if (_account_bloc.isValidLogin(
        _emailController.text.trim(),
        _passwordController.text.trim()))
    {
      _login();
    }
  }
  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String? admin = userCredential.user?.email;


      if (admin == 'admin@gmail.com') {
        // Chuyển hướng đến trang quản lý admin
        Navigator.pushReplacementNamed(context, '/screens/admin');
      }
      else {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .get();
        if (snapshot.exists) {
          Provider.of<UserData>(context, listen: false).setUid(userCredential.user?.uid ?? '');
          Provider.of<UserData>(context, listen: false).setEmail(userCredential.user?.email ?? '');
          Provider.of<UserData>(context, listen: false).setHoTen(snapshot['name'] ?? '');
          // Đăng nhập thành công, chuyển hướng qua màn hình Home hoặc thực hiện hành động cần thiết
          Navigator.pushReplacementNamed(context, '/screens/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      // Đăng nhập không thành công, hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đăng nhập thất bại'),
            content: Text('Tên tài khoản hoặc mật khẩu không chính xác'),
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
                    child: Text('Login', style: TextStyle(
                      fontSize: 50,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: StreamBuilder(
                      stream: _account_bloc.emailStream,
                      builder: (context, snapshot) => TextField(
                    controller: _emailController,
                    onTap: () {

                    },
                    style: TextStyle(),
                    decoration: InputDecoration(
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null,
                      labelText: 'Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                    ),
                  )
                ),
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
                          suffixIconColor: Colors.black54,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off,),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          labelText: 'Password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                      ),
                    )
                ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                      child: Text('Login', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                      onPressed: () {
                        _onClickeDangNhap();
                      },
                    ),
                  )
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(),));
                  },
                  child: Text('Sign Up',style: TextStyle(fontSize: 20, color: Colors.pink),),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassWord_Screen(),));
                  },
                  child: Text('Forgot Password',style: TextStyle(fontSize: 20, color: Colors.pink),),
                )
              ],
          // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

            ),
          ),
        ),
      ),
    );
  }
}
