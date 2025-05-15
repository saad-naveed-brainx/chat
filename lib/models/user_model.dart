class UserModel {
  final String id;
  final String name;

  UserModel({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  static UserModel fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], name: json['name']);
}
