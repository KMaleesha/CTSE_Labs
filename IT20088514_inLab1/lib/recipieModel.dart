//create the model class
class RecipieModel {
 
//define the variable for recipie model class
  int? id;
  String? title;
  String? description;
  List<dynamic>? ingredients; 

  RecipieModel(
    this.id,
    this.title, 
    this.description, 
    this.ingredients
    );

  // convert variables to json format
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'ingredients': ingredients,
  };

  // convert from json format
  factory RecipieModel.fromJson(Map<String, dynamic> json) => RecipieModel(
    json['id'],
    json['title'],
    json['description'],
    json['ingredients'],
  );


}