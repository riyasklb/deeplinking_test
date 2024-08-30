import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:thence_task/plant_screen.dart';

class Getplantmodel {
  List<Datum> data;

  Getplantmodel({required this.data});

  factory Getplantmodel.fromJson(Map<String, dynamic> json) => Getplantmodel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  int categoryId;
  String imageUrl;
  String name;
  double rating;
  int displaySize;
  List<int> availableSize;
  String unit;
  String price;
  String priceUnit;
  String description;

  Datum({
    required this.id,
    required this.categoryId,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.displaySize,
    required this.availableSize,
    required this.unit,
    required this.price,
    required this.priceUnit,
    required this.description,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryId: json["category_id"],
        imageUrl: json["image_url"],
        name: json["name"],
        rating: json["rating"]?.toDouble() ?? 0.0,
        displaySize: json["display_size"],
        availableSize: List<int>.from(json["available_size"].map((x) => x)),
        unit: json["unit"],
        price: json["price"],
        priceUnit: json["price_unit"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "image_url": imageUrl,
        "name": name,
        "rating": rating,
        "display_size": displaySize,
        "available_size": List<dynamic>.from(availableSize.map((x) => x)),
        "unit": unit,
        "price": price,
        "price_unit": priceUnit,
        "description": description,
      };
}

abstract class PlantEvent {}

class FetchPlants extends PlantEvent {}

abstract class PlantState {}

class PlantInitial extends PlantState {}

class PlantLoading extends PlantState {}

class PlantLoaded extends PlantState {
  final List<Datum> plants;
  PlantLoaded(this.plants);
}

class PlantError extends PlantState {
  final String message;
  PlantError(this.message);
}

class PlantBloc extends Bloc<PlantEvent, PlantState> {
  final http.Client httpClient;

  PlantBloc({required this.httpClient}) : super(PlantInitial()) {
    on<FetchPlants>(_onFetchPlants);
  }

  Future<void> _onFetchPlants(FetchPlants event, Emitter<PlantState> emit) async {
    emit(PlantLoading());
    try {
      final response = await httpClient.get(Uri.parse('https://www.jsonkeeper.com/b/6Z9C'));
      if (response.statusCode == 200) {
        final data = Getplantmodel.fromJson(json.decode(response.body));
        emit(PlantLoaded(data.data));
      } else {
        emit(PlantError('Failed to load plants'));
      }
    } catch (e) {
      emit(PlantError(e.toString()));
    }
  }
}

class PlantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Houseplants'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Houseplants',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryChip(context, 'All', true),
                _buildCategoryChip(context, 'Succulents', false),
                _buildCategoryChip(context, 'In pots', false),
                _buildCategoryChip(context, 'Dried flowers', false),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PlantBloc, PlantState>(
              builder: (context, state) {
                if (state is PlantLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is PlantLoaded) {
                  return ListView.builder(
                    itemCount: state.plants.length,
                    itemBuilder: (context, index) {
                      final plant = state.plants[index];
                      // Pass the context to the _buildPlantListTile method
                      return _buildPlantListTile(context, plant);
                    },
                  );
                } else if (state is PlantError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return Center(child: Text('No data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // Handle category selection
      },
    );
  }

  // Update the _buildPlantListTile method to accept context as a parameter
  Widget _buildPlantListTile(BuildContext context, Datum plant) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            plant.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          plant.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${plant.displaySize} cm'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.orange, size: 16),
                SizedBox(width: 4),
                Text(
                  plant.rating.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text('${plant.price} ${plant.priceUnit}', style: TextStyle(color: Colors.green)),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlantDetailScreen(
                imageUrl: plant.imageUrl,
                name: plant.name,
                rating: plant.rating,
                price: '${plant.price} ${plant.priceUnit}',
                description: plant.description,
              ),
            ),
          );
        },
      ),
    );
  }
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocProvider(
        create: (context) => PlantBloc(httpClient: http.Client())..add(FetchPlants()),
        child: PlantListScreen(),
      ),
    );
  }
}
