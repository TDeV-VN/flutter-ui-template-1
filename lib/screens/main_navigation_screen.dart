import 'package:flutter/material.dart';
import 'home_page.dart';
import 'order_page.dart';
import 'cart_page.dart';
import 'more_page.dart';
import 'product_detail_page.dart';

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  // Màu nền này sẽ là màu của BottomNavBar và vùng phía sau body nếu body không chiếm hết
  final Color _scaffoldAndNavBarColor = const Color(0xFF1F2C4C);
  final Color _bodyContentBackgroundColor = const Color(0xFFF4F6F8); // Màu nền của nội dung

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(onNavigateToProductDetails: _navigateToProductDetails),
      OrderPage(),
      CartPage(),
      MorePage(),
    ];
  }

  void _navigateToProductDetails(String productName, String imagePlaceholder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          productName: productName,
          imagePlaceholder: imagePlaceholder,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Chiều cao mong muốn cho BottomNavigationBar (bao gồm cả phần padding bạn muốn thêm)
    final double desiredNavBarHeight = kBottomNavigationBarHeight + 30.0;

    return Scaffold(
      backgroundColor: _scaffoldAndNavBarColor, // Màu nền chung
      body: SafeArea( // SafeArea cho toàn bộ body
        top: true,    // Áp dụng SafeArea cho top
        bottom: false, // Không áp dụng SafeArea cho bottom của Column này,
        // vì BottomNavBar sẽ xử lý khoảng trống của nó (nếu cần)
        child: Column( // Sử dụng Column để xếp chồng body và BottomNavBar
          children: [
            Expanded( // Phần nội dung chính chiếm không gian còn lại
              child: Container(
                decoration: BoxDecoration(
                  color: _bodyContentBackgroundColor, // Màu nền cho nội dung
                  borderRadius: BorderRadius.only(
                    // BO TRÒN GÓC DƯỚI CỦA PHẦN NỘI DUNG CHÍNH
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0),
                    // Bạn có thể bo tròn cả góc trên nếu muốn
                    // topLeft: Radius.circular(30.0),
                    // topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect( // ClipRRect để cắt nội dung theo hình dạng bo tròn
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0),
                    // topLeft: Radius.circular(30.0), // Nếu bạn cũng bo góc trên
                    // topRight: Radius.circular(30.0), // Nếu bạn cũng bo góc trên
                  ),
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _pages,
                  ),
                ),
              ),
            ),
            Container(
              height: desiredNavBarHeight + MediaQuery.of(context).padding.bottom, // Thêm padding bottom của safe area
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom), // Đảm bảo icon không bị che
              color: _scaffoldAndNavBarColor, // Màu nền cho khu vực BottomNavBar
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent, // Nền của BNB gốc trong suốt
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_outlined),
                    activeIcon: Icon(Icons.receipt_long),
                    label: 'Order',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_outlined),
                    activeIcon: Icon(Icons.shopping_cart),
                    label: 'My Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view_outlined),
                    activeIcon: Icon(Icons.grid_view_rounded),
                    label: 'More',
                  ),
                ],
                currentIndex: _currentIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withOpacity(0.7),
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: null, // Đảm bảo thuộc tính này là null hoặc không được sử dụng
    );
  }
}