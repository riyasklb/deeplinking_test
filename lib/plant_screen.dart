import 'package:flutter/material.dart';

class PlantDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final String price;
  final String description;

  const PlantDetailScreen({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl, height: 250),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  price,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 20),
                SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Choose size",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildSizeOption("18 cm"),
                _buildSizeOption("20 cm", selected: true),
                _buildSizeOption("24 cm"),
                _buildSizeOption("30 cm"),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border, size: 32),
                  onPressed: () {
                    // Add to favorites functionality
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // Add to cart functionality
                  },
                  child: Text(
                    "Add to cart",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(size),
        selected: selected,
        onSelected: (selected) {
          // Handle size selection
        },
        selectedColor: Colors.brown,
      ),
    );
  }
}
