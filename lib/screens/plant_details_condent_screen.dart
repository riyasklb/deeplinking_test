import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PlantDetailScreenContent extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final String price;
  final String description;

  const PlantDetailScreenContent({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 475,
                  height: 375,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl), // Load image from URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${price} \$',
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Color(0xFFFFBB56), size: 20),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFFFFBB56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Choose size",
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSizeOption("18 cm", false),
                  _buildSizeOption("20 cm", true), // Selected size
                  _buildSizeOption("24 cm", false),
                  _buildSizeOption("30 cm", false),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Description",
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.montserrat(
                    color: Color(0x66000000),
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF7F7F7), // light gray background
                borderRadius: BorderRadius.circular(10), // rounded corners
              ),
              child: IconButton(
                icon:
                    Icon(Icons.favorite_border, color: Colors.black, size: 24),
                onPressed: () {
                  // Handle favorite action
                },
              ),
            ),
            SizedBox(width: 8), // Add spacing between the buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB08888), // Button color #B08888
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 80, vertical: 18), // Adjust padding
              ),
              onPressed: () {
                // Handle add to cart action
              },
              child: Text(
                "Add to cart",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildSizeOption(String size, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFB08888) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          size,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Color(0x66000000),
          ),
        ),
      ),
    );
  }
}
