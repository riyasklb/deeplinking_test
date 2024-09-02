import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thence_task/block/plant_bloc.dart';
import 'package:thence_task/models/plant_model.dart';
import 'package:thence_task/screens/plant_details_condent_screen.dart';
import 'package:thence_task/screens/product_not_found_screen.dart';

class PlantDetailScreen extends StatelessWidget {
  final String id;

  PlantDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantBloc, PlantState>(
      builder: (context, state) {
        if (state is PlantLoaded) {
          final plant = state.plants.firstWhere(
            (plant) => plant.id.toString() == id,
            orElse: () => PlantList(
              id: -1,
              categoryId: -1,
              imageUrl: '',
              name: 'Not Found',
              rating: 0.0,
              displaySize: 0,
              availableSize: [],
              unit: '',
              price: '',
              priceUnit: '',
              description: 'Product not found',
            ),
          );

          if (plant.id == -1) {
            return ProductNotFoundScreen();
          }

          return PlantDetailScreenContent(
            imageUrl: plant.imageUrl,
            name: plant.name,
            rating: plant.rating,
            price: plant.price,
            description: plant.description,
          );
        } else if (state is PlantError) {
          return ProductNotFoundScreen();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
