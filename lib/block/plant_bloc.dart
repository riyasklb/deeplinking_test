import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:thence_task/models/plant_model.dart';


import '../services/plant_service.dart';

// Events
abstract class PlantEvent {}

class FetchPlants extends PlantEvent {}

// States
abstract class PlantState {}

class PlantInitial extends PlantState {}

class PlantLoading extends PlantState {}

class PlantLoaded extends PlantState {
  final GetPlantModel plants;

  PlantLoaded(this.plants);
}

class PlantError extends PlantState {
  final String message;

  PlantError(this.message);
}

// Bloc
class PlantBloc extends Bloc<PlantEvent, PlantState> {
  final http.Client httpClient;

  PlantBloc({required this.httpClient}) : super(PlantInitial()) {
    // Register the event handler for FetchPlants
    on<FetchPlants>((event, emit) async {
      emit(PlantLoading());
      try {
        final plants = await fetchPlants(httpClient);
        emit(PlantLoaded(plants));
      } catch (e) {
        emit(PlantError(e.toString()));
      }
    });
  }
}
