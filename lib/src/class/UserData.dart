
import 'package:flutter/material.dart';
class UserData extends ChangeNotifier {
  String? email;
  String? hoTen;
  String? uid;

  void setUid(String _uid) {
    uid = _uid;
    notifyListeners();
  }

  void updateUserData({String? hoTen, String? email}) {
    this.hoTen = hoTen;
    this.email = email;
    notifyListeners();
  }


  void setEmail(String _email) {
    email = _email;
    notifyListeners();
  }

  void setHoTen(String _hoTen) {
    hoTen = _hoTen;
    notifyListeners();
  }
}