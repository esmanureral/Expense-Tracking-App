import 'package:flutter/material.dart';

//HARCAMADALARDAKİ CONTAİNER

Container ExpenseContainer(Map<String, String> expense) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
    padding: const EdgeInsets.all(5.0), //İç boşluk

    decoration: BoxDecoration(
      color: Colors.orange, // harcamaların arka plan rengi
      borderRadius: BorderRadius.circular(10), //kenarları yuvarlaştırır
      boxShadow: const [
        BoxShadow(
          spreadRadius: 0.1, //Gölgenin yayılma yarıçapı
          blurRadius: 3, //Gölgenin bulanıklık yarıçapı
          offset: Offset(0, 2),
        ),
      ],
    ),

    child: ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              expense['name'] ?? '', //kutuların içindeki yazılar,harcamalar.
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold, //Yazı tipi kalın
                fontSize: 18, //Yazı tipi boyutu
              ),
              overflow: TextOverflow.ellipsis, //Metin taşarsa üç nokta ekler
            ),
          ),
          Text(
            '${expense['amount']} ₺',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold, // Yazı tipi kalın yapıldı
              fontSize: 18, // Yazı tipi boyutu ayarlandı
            ),
          ),
        ],
      ),
    ),
  );
}
