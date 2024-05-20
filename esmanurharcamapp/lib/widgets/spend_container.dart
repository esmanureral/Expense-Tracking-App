import 'package:flutter/material.dart';

// Harcama Miktarını Gösteren Container

Container SpendContainer(double totalAmount) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    child: ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Toplam Harcama',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold, // Yazı tipi kalın yapıldı
              fontSize: 18, // Yazı tipi boyutu ayarlandı
            ),
          ),
          Text(
            '${totalAmount.toStringAsFixed(2)} ₺',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}
