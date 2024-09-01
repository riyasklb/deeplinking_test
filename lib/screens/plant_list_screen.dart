import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import 'package:thence_task/block/plant_bloc.dart';
import 'package:thence_task/models/plant_model.dart';

class PlantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'All plants',
          style: GoogleFonts.montserrat(
            // Updated to Montserrat font
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: BlocBuilder<PlantBloc, PlantState>(
        builder: (context, state) {
          if (state is PlantLoading) {
            return _buildSkeletonLoader();
          } else if (state is PlantLoaded) {
            return _buildPlantList(context, state.plants.data);
          } else if (state is PlantError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Unknown State'));
          }
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 5, // Number of skeleton items to show
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Skeletonizer(
            enabled: true,
            child: ListTile(
              title: Container(
                height: 20.0,
                color: Colors.grey[300],
              ),
              subtitle: Container(
                height: 14.0,
                color: Colors.grey[300],
              ),
              leading: Container(
                width: 50.0,
                height: 50.0,
                color: Colors.grey[300],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlantList(BuildContext context, List<PlantList> plants) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildHeader(),
          _buildFilterRow(),
          Expanded(
            child: ListView.builder(
              itemCount: plants.length + 1, // +1 to account for the banner
              itemBuilder: (context, index) {
                if (index == 2) {
                  return _buildFreeShippingBanner(); // Insert the banner at index 2
                }
      
                final plantIndex =
                    index > 2 ? index - 1 : index; // Adjust index due to banner
                final plant = plants[plantIndex];
      
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      ), // Add spacing around items
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Set background color
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Image.network(
                                  plant.imageUrl,
                                  width: 100, // Increased width
                                  height: 100, // Increased height
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 4,
                              bottom: 4,
                              child: Center(
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4.0,
                                        spreadRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: Colors.grey,
                                      size: 18.0,
                                    ),
                                    onPressed: () {
                                      // Handle favorite button press
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    plant.name,
                                    style: GoogleFonts.montserrat(
                                      // Using Montserrat font
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 16.0),
                                      SizedBox(width: 4.0),
                                      Text(
                                        plant.rating.toString(),
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '${plant.displaySize} cm',
                                style: GoogleFonts.montserrat(
                                  // Using Montserrat font
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '\$${plant.price}',
                                style: GoogleFonts.montserrat(
                                  // Using Montserrat font
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Text(
            'Houseplants',
            style: GoogleFonts.montserrat(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(height: 70,
        child: ListView(scrollDirection: Axis.horizontal,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildFilterChip('All', isSelected: false),
                _buildFilterChip('Succulents', isSelected: true),
                _buildFilterChip('In pots', isSelected: false),
                _buildFilterChip('Dried flowers', isSelected: false),
              ],
            ),
          ],
        ),
      ),
    );
  }

Widget _buildFilterChip(String label, {required bool isSelected}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Handle chip selection
      },
      selectedColor: Color(0xFFB08888), // Selected chip color
      backgroundColor: Color(0xFFF4F4F4), // Unselected chip background color
      labelStyle: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
        color: isSelected ? Colors.white : Color(0x66000000), // Font color based on selection
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // No border, just rounded corners
        side: BorderSide.none, // No border
      ),
    ),
  );
}


  Widget _buildFreeShippingBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Banner.png',
              height: 120,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
