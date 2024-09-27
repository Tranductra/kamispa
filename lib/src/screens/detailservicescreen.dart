import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamispa/src/screens/updateservicescreen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String documentId;

  ServiceDetailScreen({required this.documentId});

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
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
                    'Đặt lịcht',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã đặt lịch thành công')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
