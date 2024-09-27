import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateServiceScreen extends StatefulWidget {
  final String documentId;

  UpdateServiceScreen({required this.documentId});

  @override
  _UpdateServiceScreenState createState() => _UpdateServiceScreenState();
}

class _UpdateServiceScreenState extends State<UpdateServiceScreen> {
  late TextEditingController _tenDichVuController;
  late TextEditingController _giaDichVuController;

  @override
  void initState() {
    super.initState();
    _tenDichVuController = TextEditingController();
    _giaDichVuController = TextEditingController();
    _loadServiceData();
  }

  Future<void> _loadServiceData() async {
    DocumentSnapshot serviceSnapshot = await FirebaseFirestore.instance
        .collection('services')
        .doc(widget.documentId)
        .get();

    var serviceData = serviceSnapshot.data() as Map<String, dynamic>;
    String tenDichVu = serviceData['tenDichVu'];
    String giaDichVu = serviceData['giaDichVu'];

    setState(() {
      _tenDichVuController.text = tenDichVu;
      _giaDichVuController.text = giaDichVu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cập Nhật Dịch Vụ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _giaDichVuController,
              decoration: InputDecoration(
                labelText: 'Giá Dịch Vụ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String tenDichVu = _tenDichVuController.text;
                  String giaDichVu = _giaDichVuController.text;

                  await FirebaseFirestore.instance.collection('services').doc(widget.documentId).update({
                    'tenDichVu': tenDichVu,
                    'giaDichVu': giaDichVu,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã cập nhật dịch vụ thành công'),
                    ),
                  );

                  // Thay đổi cách bạn xử lý sau khi cập nhật thành công, ví dụ: quay lại trang trước đó
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('Sửa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
