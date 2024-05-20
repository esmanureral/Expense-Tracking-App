import 'package:flutter/material.dart';
import 'package:learngooglesheets/widgets/expense_container.dart';
import 'package:learngooglesheets/widgets/spend_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OthersPage extends StatelessWidget {
  final String category;

  OthersPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Diğer Harcamalar',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 60),
            Image.asset(
              'assets/images/diğer.png',
              width: 70,
              height: 65,
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _getExpensesByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Harcama bulunamadı'));
          } else {
            final List<Map<String, String>> expenses = snapshot.data!;
            double totalAmount = 0;
            expenses.forEach((expense) {
              totalAmount += double.parse(expense['amount']!);
            });
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ExpenseContainer(expense);
                    },
                  ),
                ),
                SpendContainer(totalAmount),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, String>>> _getExpensesByCategory(
      String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedExpenses = prefs.getStringList('SpendSaveExpenses');
    List<Map<String, String>> expensesByCategory = [];

    if (savedExpenses != null) {
      savedExpenses.forEach((expenseString) {
        var expenseData = expenseString.split(',');
        if (expenseData[1] == category) {
          expensesByCategory.add({
            'name': expenseData[0],
            'category': expenseData[1],
            'amount': expenseData[2],
          });
        }
      });
    }
    return expensesByCategory;
  }
}
