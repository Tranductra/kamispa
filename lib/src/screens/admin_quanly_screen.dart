import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamispa/src/screens/admin_detailservicescreen.dart';
import 'package:kamispa/src/screens/loginscreen.dart';
import '../widgets/dichvuwidget.dart';
import 'addservicescreen.dart';
import 'detailservicescreen.dart';

class Admin_QuanLy_Screen extends StatefulWidget {
  @override
  State<Admin_QuanLy_Screen> createState() => _Admin_QuanLy_ScreenState();
}

class _Admin_QuanLy_ScreenState extends State<Admin_QuanLy_Screen> {
  Future<void> _selectService(String documentId) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Admin_ServiceDetail_Screen(documentId: documentId),
      ),
    );

    if (result != null) {
      // Xử lý kết quả nếu cần
    }
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

  @override
  Widget build(BuildContext context) {
    CollectionReference servicesCollection = FirebaseFirestore.instance.collection('services');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý thông tin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh sách dịch vụ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddServiceScreen()),
                        ).then((result) {
                          if (result != null) {
                            // Thực hiện cập nhật danh sách dịch vụ từ Firestore
                            // setState(() {});  // Bạn có thể không cần gọi setState nếu sử dụng StreamBuilder
                          }
                        });
                      },
                      icon: Icon(Icons.add_circle, color: Colors.pink),
                    )
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: servicesCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    List<DocumentSnapshot> services = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        var service = services[index].data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            _selectService(services[index].id);
                          },
                          child: DichVuWidget(
                            tenDichVu: service['tenDichVu'],
                            giaDichVu: service['giaDichVu'],
                          ),
                        );
                      },
                    );
                  },
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
