import 'package:flutter/material.dart';
import 'dart:math' as math; // Cho màu ngẫu nhiên (tùy chọn)

// --- TẠO CUSTOM SLIVERPERSISTENTHEADERDELEGATE CHO CATEGORIES ---
class CategoriesHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  CategoriesHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // shrinkOffset: giá trị từ 0 (khi maxExtent) đến (maxExtent - minExtent) (khi minExtent)
    // overlapsContent: true nếu header đang che phủ nội dung bên dưới nó
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(CategoriesHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
// --- KẾT THÚC CUSTOM DELEGATE ---


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
      const double expandedHeaderHeight = 120.0;
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

  // Widget cho phần Categories để truyền vào delegate
  Widget _buildCategoriesSection() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Màu nền cho header dính
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(), // Hoặc ClampingScrollPhysics nếu không muốn hiệu ứng nảy
            child: Row(
              children: _categories.asMap().entries.map((entry) {
                int idx = entry.key;
                Map<String, String> category = entry.value;
                return _buildCategoryChip(category['name']!, idx);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    const double bottomNavBarHeight = kBottomNavigationBarHeight + 20.0;
    const double bodyBorderRadius = 30.0;

    // Ước lượng chiều cao của phần Categories
    const double categoriesSectionHeight = 70;

    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          expandedHeight: 160.0,
          pinned: true,
          elevation: _isAppBarCollapsed ? 2.0 : 0.0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                ],
              ),
            ),
            title: _isAppBarCollapsed
                ? Text(
              "Grocery Food",
              style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
            )
                : null,
            centerTitle: true,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, size: 28, color: Colors.black54),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Search Tapped")));
              },
            ),
            SizedBox(width: 8),
          ],
        ),

        // --- SỬ DỤNG SLIVERPERSISTENTHEADER CHO CATEGORIES ---
        SliverPersistentHeader(
          pinned: true, // QUAN TRỌNG: để header này dính lại
          delegate: CategoriesHeaderDelegate(
            minHeight: categoriesSectionHeight, // Chiều cao khi đã dính
            maxHeight: categoriesSectionHeight, // Chiều cao ban đầu
            // Nếu bạn muốn nó có thể co giãn nhẹ, maxHeight có thể lớn hơn minHeight một chút
            child: _buildCategoriesSection(), // Widget chứa Categories
          ),
        ),
        // --- KẾT THÚC SLIVERPERSISTENTHEADER ---

        // Phần tiêu đề "Popular Fruits" và nút "See all"
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0, bottom: 15.0), // Thêm padding trên
            child: Row(
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

        SliverToBoxAdapter(
          child: SizedBox(height: bottomNavBarHeight + bodyBorderRadius + MediaQuery.of(context).padding.bottom + 20),
        ),
      ],
    );
  }
}