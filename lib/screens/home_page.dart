import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Function(String productName, String imagePlaceholder) onNavigateToProductDetails;

  const HomePage({Key? key, required this.onNavigateToProductDetails}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color _primaryColor = const Color(0xFF1F2C4C);
  int _selectedCategoryIndex = 0;

  final List<Map<String, String>> _categories = [
    {"name": "Fruits"},
    {"name": "Vegetables"},
    {"name": "Fast Food"},
    {"name": "Drinks"},
    {"name": "Bakery"},
  ];

  // Dữ liệu sản phẩm mẫu
  final List<Map<String, String>> _products = [
    {"name": "Apple", "cal": "55 Cal", "price": "\$10.45/kg", "image": "🍎"},
    {"name": "Orange", "cal": "75 Cal", "price": "\$14.75/kg", "image": "🍊"},
    {"name": "Melon", "cal": "156 Cal", "price": "\$25.11/kg", "image": "🍈"},
    {"name": "Dragon Fruit", "cal": "116 Cal", "price": "\$18.5/kg", "image": "🐲"},
    {"name": "Banana", "cal": "105 Cal", "price": "\$8.5/kg", "image": "🍌"},
    {"name": "Grapes", "cal": "69 Cal", "price": "\$12.0/kg", "image": "🍇"},
  ];

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
          boxShadow: !isSelected ? [
            BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0,1))
          ] : [],
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
                    decoration: BoxDecoration(
                      // color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.1),
                      // borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(imageEmoji, style: TextStyle(fontSize: 50)), // Placeholder
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: 4),
              Text(cal, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(price, style: TextStyle(fontSize: 15, color: Theme.of(context).hintColor, fontWeight: FontWeight.bold)),
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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
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
              IconButton(
                icon: Icon(Icons.search, size: 30, color: Colors.black54),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Search Tapped")));
                },
              ),
            ],
          ),
          SizedBox(height: 25),
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
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 0.72,
            children: _products.map((product) {
              return _buildProductCard(
                context,
                product['name']!,
                product['cal']!,
                product['price']!,
                product['image']!,
              );
            }).toList(),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}