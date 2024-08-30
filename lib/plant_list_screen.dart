// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:thence_task/main.dart';


// class PlantListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Houseplants'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               // Add search functionality here
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Houseplants',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildCategoryChip(context, 'All', true),
//                 _buildCategoryChip(context, 'Succulents', false),
//                 _buildCategoryChip(context, 'In pots', false),
//                 _buildCategoryChip(context, 'Dried flowers', false),
//               ],
//             ),
//           ),
//           Expanded(
//             child: BlocBuilder<PlantBloc, PlantState>(
//               builder: (context, state) {
//                 if (state is PlantLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (state is PlantLoaded) {
//                   return ListView.builder(
//                     itemCount: state.plants.length,
//                     itemBuilder: (context, index) {
//                       final plant = state.plants[index];
//                       return _buildPlantListTile(context, plant);
//                     },
//                   );
//                 } else if (state is PlantError) {
//                   return Center(child: Text('Error: ${state.message}'));
//                 } else {
//                   return Center(child: Text('No data'));
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryChip(BuildContext context, String label, bool isSelected) {
//     return ChoiceChip(
//       label: Text(label),
//       selected: isSelected,
//       onSelected: (selected) {
//         // Handle category selection
//       },
//     );
//   }

//   Widget _buildPlantListTile(BuildContext context, Datum plant) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(8),
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(8.0),
//           child: Image.network(
//             plant.imageUrl,
//             width: 60,
//             height: 60,
//             fit: BoxFit.cover,
//           ),
//         ),
//         title: Text(
//           plant.name,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text('${plant.displaySize} cm'),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.star, color: Colors.orange, size: 16),
//                 SizedBox(width: 4),
//                 Text(
//                   plant.rating.toString(),
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             Text('${plant.price} ${plant.priceUnit}', style: TextStyle(color: Colors.green)),
//           ],
//         ),
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => PlantDetailScreen(
//                 imageUrl: plant.imageUrl,
//                 name: plant.name,
//                 rating: plant.rating,
//                 price: '${plant.price} ${plant.priceUnit}',
//                 description: plant.description,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
