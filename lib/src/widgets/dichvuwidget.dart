import 'package:flutter/material.dart';

class DichVuWidget extends StatelessWidget {
  final String tenDichVu;
  final String giaDichVu;
  DichVuWidget({required this.tenDichVu, required this.giaDichVu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  tenDichVu,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis, // Để cắt bớt khi quá dài
                  ),
                ),
              ),
              Text(giaDichVu, style: TextStyle(fontSize: 13))
            ],
          ),
        ),
      ),
    );
  }
}
