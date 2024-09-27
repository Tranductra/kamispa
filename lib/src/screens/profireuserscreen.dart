import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kamispa/src/screens/loginscreen.dart';
import 'package:provider/provider.dart';

import '../class/UserData.dart';

class ProfileUser_Screen extends StatefulWidget {
  const ProfileUser_Screen({super.key});
  @override
  State<ProfileUser_Screen> createState() => _ProfileUser_ScreenState();
}

class _ProfileUser_ScreenState extends State<ProfileUser_Screen> {

  bool _readOnlyHoTen = true;
  bool _readOnlyEmail = true;

  final TextEditingController _hoTenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  late UserData _userData = UserData();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userData = Provider.of<UserData>(context, listen: false);
      _hoTenController.text = _userData.hoTen ?? '';
      _emailController.text = _userData.email ?? '';
    }); // fix loi Provider xu li qua trang
  }

  Future<void> _dangXuat() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Đăng nhập thành công, chuyển hướng qua màn hình Home hoặc thực hiện hành động cần thiết
      // Navigator.pushReplacementNamed(context, '/screens/dangnhap');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      // Đăng nhập không thành công, hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đăng xuất thất bại'),
            content: Text('Có lỗi xảy ra. Vui lòng thử lại'),
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
  Future<void> _luuThongTinCaNhan() async {
    // User? user = FirebaseAuth.instance.currentUser;
    try {
      // Thay đổi email đăng nhập
      // await user?.updateEmail(_emailController.text);
      // Tạo một tham chiếu đến tài khoản người dùng trong Firestore
      var userRef = FirebaseFirestore.instance.collection('users').doc(_userData.uid);

      // Bắt đầu quá trình cập nhật thông tin
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Đọc dữ liệu hiện tại từ Firestore
        DocumentSnapshot snapshot = await transaction.get(userRef);

        // Kiểm tra xem tài khoản người dùng có tồn tại hay không
        if (snapshot.exists) {
          // Cập nhật thông tin mới
          transaction.update(userRef, {
            'name': _hoTenController.text,
            'email': _emailController.text,
          });

          // Cập nhật dữ liệu trong Provider
          Provider.of<UserData>(context, listen: false).updateUserData(
            hoTen: _hoTenController.text,
            email: _emailController.text,
          );
        }
      });

      // Hiển thị thông báo lưu thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thông tin đã được cập nhật')),
      );

      // Tắt chế độ chỉ đọc
      setState(() {
        _readOnlyHoTen = true;
        _readOnlyEmail = true;
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi cập nhật thông tin: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi. Vui lòng thử lại sau')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân', style: TextStyle(
            color: Colors.black, fontSize: 20
        ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                TextField(
                  style: TextStyle(color: _readOnlyHoTen ? Colors.black : Colors.teal, fontSize: 20),
                  controller: _hoTenController,
                  readOnly: _readOnlyHoTen,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Họ tên',
                      prefixIcon: Icon(Icons.supervised_user_circle_outlined, size: 30,),
                      suffixIcon: IconButton(onPressed: () {
                        setState(() {
                          _readOnlyHoTen = !_readOnlyHoTen;
                        });
                      },
                        icon: Icon(Icons.edit), iconSize: 30,)
                  ),
                ),


                SizedBox(height: 10,),
                TextField(
                  style: TextStyle(color: _readOnlyEmail ? Colors.black : Colors.teal, fontSize: 20),
                  controller: _emailController,
                  readOnly: _readOnlyEmail,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline, size: 30,),
                      suffixIcon: IconButton(onPressed: () {
                        setState(() {
                          _readOnlyEmail = !_readOnlyEmail;
                        });
                      },
                        icon: Icon(Icons.edit), iconSize: 30,)
                  ),
                ),
                SizedBox(height: 40,),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xffD8D8D8)
                    ),
                    onPressed: () {
                      _luuThongTinCaNhan();
                    },
                    child: Text('Lưu thông tin', style: TextStyle(fontWeight: FontWeight.w600),),
                  ),
                ),
                SizedBox(height: 230,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    onPressed: () {
                      _dangXuat();
                    },
                  ),
                  ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



