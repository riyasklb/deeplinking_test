// To parse this JSON data, do
//
//     final getplantmodel = getplantmodelFromJson(jsonString);

import 'dart:convert';

GetPlantModel getplantmodelFromJson(String str) =>
    GetPlantModel.fromJson(json.decode(str));

String getplantmodelToJson(GetPlantModel data) => json.encode(data.toJson());

class GetPlantModel {
  List<PlantList> data;

  GetPlantModel({
    required this.data,
  });

  factory GetPlantModel.fromJson(Map<String, dynamic> json) => GetPlantModel(
        data: List<PlantList>.from(
            json["data"].map((x) => PlantList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PlantList {
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

  PlantList({
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

  factory PlantList.fromJson(Map<String, dynamic> json) => PlantList(
        id: json["id"],
        categoryId: json["category_id"],
        imageUrl: json["image_url"],
        name: json["name"],
        rating: json["rating"]?.toDouble(),
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
