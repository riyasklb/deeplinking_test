import 'package:go_router/go_router.dart';
import 'package:thence_task/screens/plant_details_screen.dart';
import 'screens/plant_list_screen.dart';

import 'screens/product_not_found_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => PlantListScreen(),
      ),
      GoRoute(
        path: '/flutter/assignment/product/:id',
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
}
