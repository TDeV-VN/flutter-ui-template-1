import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart'; // Đảm bảo đường dẫn này đúng với cấu trúc thư mục của bạn

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Bạn có thể giữ lại biến này nếu bạn sử dụng nó ở nhiều nơi,
  // hoặc trực tiếp dùng giá trị màu trong ThemeData.
  final Color _navBarBackgroundColor = const Color(0xFF1F2C4C);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF1F2C4C), // Màu chính của app
        hintColor: Colors.deepOrangeAccent,   // Màu phụ (ví dụ: cho giá, nút add), bạn có thể chọn màu khác
        scaffoldBackgroundColor: const Color(0xFFF4F6F8), // Màu nền chung cho body
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // (Tùy chọn - thêm font 'Poppins' vào pubspec.yaml và thư mục assets/fonts nếu muốn)

        // Định nghĩa các kiểu mặc định cho BottomNavigationBar
        // Các thuộc tính này sẽ được BottomNavigationBar sử dụng nếu không bị ghi đè cục bộ.
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          // backgroundColor: _navBarBackgroundColor,
          // Nếu bạn đặt màu nền cho Container bọc BottomNavigationBar,
          // bạn có thể không cần đặt backgroundColor ở đây, hoặc đặt nó thành transparent
          // để tránh xung đột màu. Tuy nhiên, để nó ở đây cũng không sao nếu bạn quản lý tốt.
          // Trong trường hợp bọc bằng Container có màu, thì màu của Container sẽ được ưu tiên.
          backgroundColor: _navBarBackgroundColor, // Đảm bảo màu này khớp với Container bọc NavBar

          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          elevation: 0, // Bỏ shadow mặc định nếu bạn muốn
          // DÒNG 'height' GÂY LỖI ĐÃ ĐƯỢC XÓA HOÀN TOÀN KHỎI ĐÂY
        ),

        // Bạn cũng có thể định nghĩa các theme khác ở đây
        // textTheme: TextTheme(
        //   headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black87),
        //   bodyText2: TextStyle(fontSize: 14.0, color: Colors.black54),
        // ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: const Color(0xFF1F2C4C),
        //     foregroundColor: Colors.white,
        //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        //     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(25.0),
        //     ),
        //   ),
        // ),
      ),
      home: MainNavigationScreen(), // Widget màn hình chính của bạn
    );
  }
}