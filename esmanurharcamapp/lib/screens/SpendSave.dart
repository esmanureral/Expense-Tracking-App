import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learngooglesheets/widgets/spend_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpendSave extends StatefulWidget {
  @override
  _SpendSaveState createState() => _SpendSaveState();
}

class _SpendSaveState extends State<SpendSave> {
  //harcama adı ve tutarını girmek için;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final List<Map<String, String>> _expenses = [];

  String _selectedCategory = 'Yemek';

  double _totalAmount = 0; // Toplam harcama miktarını tutmak için değişken

  @override
  void initState() {
    super.initState();
    _loadExpenses(); // Sayfa yüklendiğinde kaydedilmiş harcamaları yükle
  }

  void _loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedExpenses = prefs.getStringList('SpendSaveExpenses');

    if (savedExpenses != null) {
      setState(() {
        _expenses.clear();
        savedExpenses.forEach((expenseString) {
          var expenseData = expenseString.split(',');
          _expenses.add({
            'name': expenseData[0],
            'category': expenseData[1],
            'amount': expenseData[2],
          });
        });
        _updateTotalAmount(); // Harcamalar yüklendikten sonra toplam miktarı güncelle
      });
    }
  }

  Future<void> _addExpense() async {
    final name = _nameController.text;
    final category = _selectedCategory;
    final amount = _expenseController.text;

    if (name.isNotEmpty && amount.isNotEmpty) {
      _expenses.add({
        'name': name,
        'category': category,
        'amount': amount,
      });
      _nameController.clear();
      _expenseController.clear();

      // Harcama eklendikten sonra SharedPreferences'e kaydet
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> expenseStrings = _expenses
          .map((expense) =>
              '${expense['name']},${expense['category']},${expense['amount']}')
          .toList();
      await prefs.setStringList('SpendSaveExpenses', expenseStrings);

      // Yeni harcama eklendikten sonra sayfayı yenile
      _loadExpenses();
    }
  }

  void _removeExpense(int index) async {
    _expenses.removeAt(index);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> expenseStrings = _expenses
        .map((expense) =>
            '${expense['name']},${expense['category']},${expense['amount']}')
        .toList();
    await prefs.setStringList('SpendSaveExpenses', expenseStrings);
    setState(() {
      _updateTotalAmount(); // Harcama kaldırıldıktan sonra toplam miktarı güncelle
    });
  }

  // Toplam miktarı güncelleyen yardımcı fonksiyon
  void _updateTotalAmount() {
    double total = 0;
    _expenses.forEach((expense) {
      total += double.parse(expense['amount'] ?? '0');
    });
    setState(() {
      _totalAmount = total;
    });
  }

//HARCAMALARI KAYDIR VE SİL
  Widget _buildExpenseList() {
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        return Dismissible(
          key: Key(expense['name']!),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Harcamayı Sil",
                    style: TextStyle(fontSize: 25),
                  ),
                  content: const Text(
                    "Bu harcamayı silmek istediğinizden emin misiniz?",
                    style: TextStyle(fontSize: 18),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        "Sil",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        "İptal",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },

          //harcama öğesini listeleme,kullanıcının harcamayı silmek için kaydırma
          onDismissed: (direction) {
            _removeExpense(index);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.red, // harcamaların arka plan rengi
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
              title: Text(
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                expense['name'] ?? '',
              ),
              subtitle: Text(expense['category'] ?? '',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600)),
              trailing: Text('${expense['amount']} ₺',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Harcamaları Kaydet',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 55),
            Image.asset(
              'assets/images/kaydet.png',
              width: 50,
              height: 70,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Harcama Ekle',
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'İsim',
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategory = newValue!;
                              });
                            },
                            items: <String>[
                              'Yemek',
                              'Giyim',
                              'Ulaşım',
                              'Diğer',
                              "Eğitim"
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),

                          //Harcama ekle butonu
                          TextField(
                            controller: _expenseController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Fiyat (₺)',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _addExpense();
                          },
                          child: const Text('Ekle'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('İptal'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Buton metninin rengi
                backgroundColor: const Color.fromARGB(
                    255, 47, 61, 107), // Butonun arka plan rengi
                padding: const EdgeInsets.symmetric(
                  horizontal: 140, // Yatay dolgu
                  vertical: 15, // Dikey dolgu
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Butonun köşe yarıçapı
                ),
              ),
              child: const Text(
                'Harcama Ekle',
              ),
            ),
          ),

          ////////////////ANA Sayfadaki tutar//////////////////////////////////
          Expanded(
            child: _buildExpenseList(),
          ),
          SpendContainer(_totalAmount)
        ],
      ),
    );
  }
}
