import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learngooglesheets/screens/SpendSave.dart';
import 'package:learngooglesheets/screens/education_page.dart';
import 'package:learngooglesheets/screens/food_page.dart';
import 'package:learngooglesheets/screens/clothes_page.dart';
import 'package:learngooglesheets/screens/save_page.dart';
import 'package:learngooglesheets/screens/others_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  late PageController _pageController;
  static final List<Widget> _pages = <Widget>[
    const ClothesPage(category: "Giyim"),
    const EducationPage(category: "Eğitim"),
    FoodPage(category: "Yemek"),
    SpendSave(),
    const SavePage(category: "Ulaşım"),
    OthersPage(category: "Diğer"),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 47, 61, 107), //anasayfanın üst kısmı
        title: const Text(
          'Ana Sayfa',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 47, 61, 107), //ana sayfanın alt kısmı
        buttonBackgroundColor: Colors.orange,
        items: <Widget>[
          const Icon(Icons.shopping_bag_outlined,
              size: 30, color: Colors.white),
          const Icon(Icons.school_outlined, size: 30, color: Colors.white),
          const Icon(Icons.food_bank_outlined, size: 30, color: Colors.white),
          const Icon(Icons.assignment_outlined, size: 30, color: Colors.white),
          const Icon(Icons.flight_outlined, size: 30, color: Colors.white),
          const Icon(Icons.more_outlined, size: 30, color: Colors.white),
          // Eğitim ikonu
        ].map((Widget icon) => CurvedNavigationBarItem(child: icon)).toList(),
        onTap: _onItemTapped,
        index: _selectedIndex,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}
