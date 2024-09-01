import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:thence_task/block/plant_bloc.dart';
import 'router.dart';


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
    final goRouter = createRouter();

    return MaterialApp.router(
      routerConfig: goRouter,
    );
  }
}
