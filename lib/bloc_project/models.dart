class User{
  User({this.id = '00000000-0000-0000-0000-000000000000', this.userFullName, this.userEmail, required this.userPassword});
  String id = '00000000-0000-0000-0000-000000000000';
  String? userFullName;
  String? userEmail;
  String? userPassword;
  
  Map<String, dynamic> toJson() => {"id": id, "full_name": userFullName, "email": userEmail, "password": userPassword};

  factory User.fromJson(Map<String, dynamic> json){
    return User(id: json["id"], userFullName: json["full_name"],
     userEmail: json["email"], userPassword: json["password"]);
  }
}