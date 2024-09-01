import 'package:flutter/material.dart';

class PlantDetailScreen extends StatelessWidget {
  final String id;

  PlantDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Details'),
      ),
      body: Center(
        child: Text('Details of plant with ID: $id'),
      ),
    );
  }
}
