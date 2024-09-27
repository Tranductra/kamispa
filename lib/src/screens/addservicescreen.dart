import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddServiceScreen extends StatefulWidget {
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  TextEditingController _tenDichVuController = TextEditingController();
  TextEditingController _giaDichVuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Dịch Vụ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tenDichVuController,
              decoration: InputDecoration(
                  labelText: 'Tên Dịch Vụ',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _giaDichVuController,
              decoration: InputDecoration(labelText: 'Giá Dịch Vụ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
              ),
            SizedBox(height: 16),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String tenDichVu = _tenDichVuController.text;
                  String giaDichVu = _giaDichVuController.text;

                  // Thêm dữ liệu vào Firestore
                  await FirebaseFirestore.instance.collection('services').add({
                    'tenDichVu': tenDichVu,
                    'giaDichVu': giaDichVu,
                  });

                  // Hiển thị thông báo sau khi thêm thành công
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm dịch vụ thành công'),
                    ),
                  );

                  // Clear TextField
                  _tenDichVuController.clear();
                  _giaDichVuController.clear();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
                child: Text('Thêm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
