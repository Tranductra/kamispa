import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamispa/src/screens/updateservicescreen.dart';

class Admin_ServiceDetail_Screen extends StatefulWidget {
  final String documentId;

  Admin_ServiceDetail_Screen({required this.documentId});

  @override
  _Admin_ServiceDetail_ScreenState createState() => _Admin_ServiceDetail_ScreenState();
}

class _Admin_ServiceDetail_ScreenState extends State<Admin_ServiceDetail_Screen> {
  late  String _tenDichVu = '';
  late String _giaDichVu = '';
  late DateTime _thoiGianCapNhat = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Hoặc bạn có thể sử dụng giá trị từ Firestore
    _loadServiceData();
  }

  Future<void> _loadServiceData() async {
    try {
      DocumentSnapshot serviceSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .doc(widget.documentId)
          .get();

      if (serviceSnapshot.exists) {
        var serviceData = serviceSnapshot.data() as Map<String, dynamic>;
        if (serviceData != null) {
          setState(() {
            _tenDichVu = serviceData['tenDichVu'] ?? ""; // Sử dụng "??"" để xử lý giá trị null
            _giaDichVu = serviceData['giaDichVu'] ?? "";

            // Kiểm tra và xử lý trường thoiGianCapNhat
            var thoiGianCapNhat = serviceData['thoiGianCapNhat'];
            _thoiGianCapNhat = (thoiGianCapNhat is Timestamp) ? thoiGianCapNhat.toDate() : DateTime.now();
          });
        } else {
          print("serviceData is null");
        }
      } else {
        print("Service document does not exist");
      }
    } catch (error) {
      print("Error loading service data: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi Tiết Dịch Vụ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                // Điều hướng đến trang sửa dịch vụ
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateServiceScreen(documentId: widget.documentId),
                  ),
                );
                // Sau khi quay lại từ trang sửa, load lại dữ liệu
                _loadServiceData();
              } else if (value == 'delete') {
                // Hiển thị hộp thoại xác nhận xóa
                _showDeleteConfirmationDialog();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Sửa Dịch Vụ'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Xóa Dịch Vụ'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên Dịch Vụ: $_tenDichVu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Giá Dịch Vụ: $_giaDichVu',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Thời Gian Cập Nhật: $_thoiGianCapNhat',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị hộp thoại xác nhận xóa
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác Nhận Xóa'),
          content: Text('Bạn có chắc chắn muốn xóa dịch vụ này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('services').doc(widget.documentId).delete();
                Navigator.of(context).pop(); // Đóng hộp thoại xác nhận xóa
                Navigator.of(context).pop(); // Đóng trang chi tiết dịch vụ sau khi xóa
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
