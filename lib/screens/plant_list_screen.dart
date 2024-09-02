import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import 'package:thence_task/block/plant_bloc.dart';
import 'package:thence_task/models/plant_model.dart';
import 'package:intl/intl.dart';

class PlantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<PlantBloc, PlantState>(
        builder: (context, state) {
          if (state is PlantLoading) {
            return _buildSkeletonLoader();
          } else if (state is PlantLoaded) {
            return _buildPlantList(context, state.plants);
          } else if (state is PlantError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Unknown State'));
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'All plants',
        style: GoogleFonts.montserrat(
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
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: [
        _buildChipSkeletonRow(),
        Expanded(
          child: ListView.builder(
            itemCount: 5, // Number of skeleton items to show
            itemBuilder: (context, index) => _buildSkeletonItem(),
          ),
        ),
      ],
    );
  }

  Widget _buildChipSkeletonRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _buildChipSkeleton(),
          ),
        ),
      ),
    );
  }

  Widget _buildChipSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        width: 80.0,
        height: 30.0,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  Widget _buildSkeletonItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeletonizer(
              enabled: true,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonText(height: 20.0),
                  SizedBox(height: 4.0),
                  _buildSkeletonText(height: 14.0),
                  SizedBox(height: 4.0),
                  _buildSkeletonText(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonText({required double height}) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        height: height,
        color: Colors.grey[300],
      ),
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
              itemCount: plants.length + 1, // +1 for the banner
              itemBuilder: (context, index) {
                if (index == 2) {
                  return _buildFreeShippingBanner();
                }
                final plantIndex = index > 2 ? index - 1 : index;
                final plant = plants[plantIndex];
                return _buildPlantItem(context, plant);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
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
      padding: const EdgeInsets.only(bottom: 16.0, top: 18),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildFilterChip('All', isSelected: false),
            _buildFilterChip('Succulents', isSelected: true),
            _buildFilterChip('In pots', isSelected: false),
            _buildFilterChip('Dried flowers', isSelected: false),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFB08888) : Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Color(0x66000000),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlantItem(BuildContext context, PlantList plant) {
    return GestureDetector(
      onTap: () {
        // Navigate to the PlantDetailScreen with the plant ID
        context.go('/flutter/assignment/product/${plant.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlantImage(plant.imageUrl),
              SizedBox(width: 16.0),
              Expanded(
                child: _buildPlantDetails(plant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlantImage(String imageUrl) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Image.network(
              imageUrl,
              width: 112,
              height: 112,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
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
      ],
    );
  }

  Widget _buildPlantDetails(PlantList plant) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plant.name,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Color(0xFFFFBB56), size: 16.0),
                  SizedBox(width: 4.0),
                  Text(
                    plant.rating.toString(),
                    style: TextStyle(
                        color: Color(0xFFFFBB56),
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Text(
            '${plant.displaySize} cm',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            '${plant.price} \$',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeShippingBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: double.infinity,
        child: SvgPicture.asset(
          'assets/images/Banner (1).svg',
          height: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
