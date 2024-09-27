import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kamispa/src/blocs/account_bloc.dart';


class ForgotPassWord_Screen extends StatefulWidget {
  const ForgotPassWord_Screen({super.key});
  @override
  State<ForgotPassWord_Screen> createState() => _ForgotPassWord_ScreenState();
}

class _ForgotPassWord_ScreenState extends State<ForgotPassWord_Screen> {
  TextEditingController _emailController = new TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  // Bloc
  Account_Bloc _account_bloc = Account_Bloc();
  _onClickeQuenMatKhau() {
    if (_account_bloc.isValidForgotPassWord(_emailController.text.trim())) {
      _quenMatKhau(_emailController.text.trim());
    }
  }

  @override
  void dispose() {
    _account_bloc.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _quenMatKhau(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đã gửi liên kết!'),
            content: Text('Vui lòng kiểm tra lại email của bạn.'),
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
    } on FirebaseAuthException catch (e) {
      // Đăng nhập không thành công, hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Có lỗi xảy ra'),
            content: Text(
                'Vui lòng thử lại sau do hệ thống đang gặp lỗi. Xin cảm ơn'),
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
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.cyanAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 41),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  child: Text(
                    'Plese confirm your email in the box',
                    style: TextStyle(
                        fontSize: 14, color: Color(0xffAAAAAA)),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    child: StreamBuilder(
                        stream: _account_bloc.emailStream,
                        builder: (context, snapshot) => TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                size: 25,
                              ),
                              errorText: snapshot.hasError
                                  ? snapshot.error.toString()
                                  : null,
                              labelText: 'Your email',
                              labelStyle: TextStyle(
                                  fontSize: 12, color: Color(0xffC1C7D0))),
                        ))),
                SizedBox(height: 140),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text(
                        'Complete',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                      onPressed: () {
                        _onClickeQuenMatKhau();
                      },
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
