import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/plant_model.dart';

Future<GetPlantModel> fetchPlants(http.Client client) async {
  final response = await client.get(Uri.parse('https://www.jsonkeeper.com/b/6Z9C'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      return GetPlantModel.fromJson(jsonResponse);
    } else {
      return GetPlantModel(data: []);  // Returning an empty list if response is null
    }
  } else {
    throw Exception('Failed to load plants');
  }
}

