import 'package:flutter/material.dart';
import 'dart:math' as math; // Cho màu ngẫu nhiên (tùy chọn)

class HomePage extends StatefulWidget {
  final Function(String productName, String imagePlaceholder) onNavigateToProductDetails;

  const HomePage({Key? key, required this.onNavigateToProductDetails}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color _primaryColor = const Color(0xFF1F2C4C);
  int _selectedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarCollapsed = false;

  final List<Map<String, String>> _categories = [
    {"name": "Fruits"},
    {"name": "Vegetables"},
    {"name": "Fast Food"},
    {"name": "Drinks"},
    {"name": "Bakery"},
  ];

  final List<Map<String, String>> _products = [
    {"name": "Apple", "cal": "55 Cal", "price": "\$10.45/kg", "image": "🍎"},
    {"name": "Orange", "cal": "75 Cal", "price": "\$14.75/kg", "image": "🍊"},
    {"name": "Melon", "cal": "156 Cal", "price": "\$25.11/kg", "image": "🍈"},
    {"name": "Dragon Fruit", "cal": "116 Cal", "price": "\$18.5/kg", "image": "🐲"},
    {"name": "Banana", "cal": "105 Cal", "price": "\$8.5/kg", "image": "🍌"},
    {"name": "Grapes", "cal": "69 Cal", "price": "\$12.0/kg", "image": "🍇"},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // Giả sử chiều cao mở rộng của SliverAppBar khoảng 150 và chiều cao thu gọn (toolbar) khoảng 56 (kToolbarHeight)
      // Chúng ta muốn biết khi nào phần flexibleSpace đã cuộn gần hết
      // Offset khi SliverAppBar chỉ còn lại phần title/actions (đã pinned)
      // Độ cao của phần tiêu đề lớn "Daily Grocery Food" + khoảng trống
      const double expandedHeaderHeight = 120.0; // Ước lượng chiều cao của phần header lớn
      if (_scrollController.hasClients &&
          _scrollController.offset > (expandedHeaderHeight - kToolbarHeight)) {
        if (!_isAppBarCollapsed) {
          setState(() {
            _isAppBarCollapsed = true;
          });
        }
      } else {
        if (_isAppBarCollapsed) {
          setState(() {
            _isAppBarCollapsed = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildCategoryChip(String label, int index) {
    // ... (code không đổi)
    bool isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
          boxShadow: !isSelected
              ? [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1))
          ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String cal, String price, String imageEmoji) {
    // ... (code không đổi)
    return GestureDetector(
      onTap: () {
        widget.onNavigateToProductDetails(name, imageEmoji);
      },
      child: Card(
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(imageEmoji, style: TextStyle(fontSize: 50)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              SizedBox(height: 4),
              Text(cal, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(price,
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Chiều cao của BottomNavBar, bạn cần lấy giá trị này từ MainNavigationScreen
    // hoặc định nghĩa một hằng số chung. Tạm thời dùng giá trị cố định.
    const double bottomNavBarHeight = kBottomNavigationBarHeight + 20.0; // Ví dụ
    const double bodyBorderRadius = 30.0;

    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Màu nền của AppBar khi thu gọn
          expandedHeight: 160.0, // Chiều cao khi mở rộng (chứa "Daily Grocery Food")
          pinned: true, // Ghim AppBar lại khi cuộn
          elevation: _isAppBarCollapsed ? 2.0 : 0.0, // Thêm shadow khi thu gọn
          automaticallyImplyLeading: false, // Tắt nút back mặc định
          flexibleSpace: FlexibleSpaceBar(
            // titlePadding: EdgeInsets.zero, // Bỏ padding mặc định của title
            background: Padding( // Phần header lớn
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0, bottom: 10.0), // Điều chỉnh padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end, // Căn cuối để gần với phần content
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.black54),
                      ),
                      Text(
                        "Grocery Food",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.2),
                      ),
                    ],
                  ),
                  // Icon tìm kiếm sẽ hiển thị trong actions khi thu gọn
                ],
              ),
            ),
            // Phần title này sẽ chỉ hiển thị khi AppBar thu gọn đáng kể (nếu có)
            // Bạn có thể để trống hoặc hiển thị một tiêu đề nhỏ hơn
            title: _isAppBarCollapsed
                ? Text(
              "Grocery Food",
              style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
            )
                : null, // Để trống khi chưa thu gọn hẳn
            centerTitle: true, // Căn giữa title thu gọn
          ),
          actions: <Widget>[ // Actions sẽ luôn hiển thị
            IconButton(
              icon: Icon(Icons.search, size: 28, color: Colors.black54),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Search Tapped")));
              },
            ),
            SizedBox(width: 8),
          ],
        ),

        // Phần Categories
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: _categories.asMap().entries.map((entry) {
                      int idx = entry.key;
                      Map<String, String> category = entry.value;
                      return _buildCategoryChip(category['name']!, idx);
                    }).toList(),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular ${_categories[_selectedCategoryIndex]['name']}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("See all", style: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),

        // Lưới sản phẩm
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final product = _products[index];
                return _buildProductCard(
                  context,
                  product['name']!,
                  product['cal']!,
                  product['price']!,
                  product['image']!,
                );
              },
              childCount: _products.length,
            ),
          ),
        ),

        // Padding ở dưới cùng để không bị che bởi BottomNavigationBar
        // (cần tính toán chính xác dựa trên chiều cao NavBar và bo góc của body)
        SliverToBoxAdapter(
          child: SizedBox(height: bottomNavBarHeight + bodyBorderRadius + MediaQuery.of(context).padding.bottom + 20),
        ),
      ],
    );
  }
}