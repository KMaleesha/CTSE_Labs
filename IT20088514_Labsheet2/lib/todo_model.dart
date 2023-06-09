class TODOModel {

  int? id;
  String? task;
  String? name;
  int? status; 

  TODOModel(
    this.id,
    this.task, 
    this.name, 
    this.status
    );

  Map<String, dynamic> toJson() => {
    'id': id,
    'task': task,
    'name': name,
    'status': status,
  };

  factory TODOModel.fromJson(Map<String, dynamic> json) => TODOModel(
    json['id'],
    json['task'],
    json['name'],
    json['status'],
  );


}