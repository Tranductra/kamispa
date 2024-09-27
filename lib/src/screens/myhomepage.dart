import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamispa/src/screens/profireuserscreen.dart';
import 'package:kamispa/src/screens/updateservicescreen.dart';
import 'package:provider/provider.dart';

import '../class/UserData.dart';
import '../widgets/dichvuwidget.dart';
import 'addservicescreen.dart';
import 'detailservicescreen.dart';
import 'loginscreen.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _selectService(String documentId) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailScreen(documentId: documentId),
      ),
    );

    if (result != null) {
      // Xử lý kết quả nếu cần
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference servicesCollection = FirebaseFirestore.instance.collection('services');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<UserData>(context).hoTen ?? 'User',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        actions: [
          CircleAvatar(
            child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUser_Screen(),));
                },
                icon: Icon(Icons.account_circle_rounded)),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 120,
                  child: Image.asset('assets/images/logo.png'),
                ),
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.cyan,
        showUnselectedLabels: true,
        onTap: (int index) {
          // Xử lý khi nút được chọn
          switch (index) {
            case 0:
            // Xử lý khi nhấn nút Home
              break;
            case 1:
            // Xử lý khi nhấn nút Transaction
              break;
            case 2:
            // Xử lý khi nhấn nút Customer
              break;
            case 3:
            // Xử lý khi nhấn nút Setting
              break;
          }
        },
      ),
    );
  }
}
