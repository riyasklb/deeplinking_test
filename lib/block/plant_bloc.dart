import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:thence_task/models/plant_model.dart';

abstract class PlantEvent {}

class FetchPlants extends PlantEvent {}

abstract class PlantState {}

class PlantInitial extends PlantState {}

class PlantLoading extends PlantState {}

class PlantLoaded extends PlantState {
  final List<PlantList> plants;
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

  Future<void> _onFetchPlants(
      FetchPlants event, Emitter<PlantState> emit) async {
    emit(PlantLoading());
    try {
      final response =
          await httpClient.get(Uri.parse('https://www.jsonkeeper.com/b/6Z9C'));
      if (response.statusCode == 200) {
        final data = GetPlantModel.fromJson(json.decode(response.body));
        emit(PlantLoaded(data.data));
      } else {
        emit(PlantError('Failed to load plants'));
      }
    } catch (e) {
      emit(PlantError(e.toString()));
    }
  }
}
