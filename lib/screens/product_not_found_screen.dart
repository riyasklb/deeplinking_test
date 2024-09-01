import 'package:flutter/material.dart';

class ProductNotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Not Found'),
      ),
      body: Center(
        child: Text('404: Product Not Found'),
      ),
    );
  }
}
