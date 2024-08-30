import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  final plantBloc = PlantBloc(httpClient: http.Client());

  runApp(
    BlocProvider(
      create: (context) => plantBloc..add(FetchPlants()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => PlantListScreen(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return PlantDetailScreen(id: id);
          },
        ),
        GoRoute(
          path: '/404',
          builder: (context, state) => ProductNotFoundScreen(),
        ),
      ],
      errorBuilder: (context, state) {
        return ProductNotFoundScreen();
      },
    );

    return MaterialApp.router(
      routerConfig:goRouter
    );
  }
}

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
          context.go('/product/${plant.id}');
        },
      ),
    );
  }
}

class PlantDetailScreen extends StatelessWidget {
  final String id;

  const PlantDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantBloc, PlantState>(
      builder: (context, state) {
        if (state is PlantLoaded) {
          final plant = state.plants.firstWhere(
            (plant) => plant.id.toString() == id,
            orElse: () => Datum(
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
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl),
            SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 20),
                SizedBox(width: 4),
                Text(rating.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Text(price, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 16),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class ProductNotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product not found', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
