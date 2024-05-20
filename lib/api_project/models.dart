import 'package:equatable/equatable.dart';

class Posts extends Equatable{
  const Posts({this.id = -1, this.title, this.body, this.userId, this.tags, this.reactions = 0});

  final int id;
  final String? title;
  final String? body;
  final int? userId;
  final List<String>? tags;
  final int reactions;

  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'title':title,
      'body':body,
      'userId':userId,
      'tags': tags,
      'reactions': reactions,
    };
  }
  factory Posts.fromJson(Map<String, dynamic> json){
    return Posts(id: json["id"], title: json["title"], body: json["body"], userId: json["userId"], tags: List<String>.from(json["tags"]), reactions: json["reactions"]);
  }

  @override
  List<Object?> get props => [id, title, body, userId, tags, reactions];
}

class Hair extends Equatable{
  const Hair({this.color, this.type});
  final String? color;
  final String? type;

  factory Hair.fromJson(Map<String,dynamic> json){
    return Hair(color: json["color"], type: json["type"]);
  }


  @override
  List<Object?> get props => [color, type];
}

class Coordinates{
  const Coordinates({required this.lat, required this.lng});
  final double lat;
  final double lng;
  
  factory Coordinates.fromJson(Map<String, dynamic> json){
    return Coordinates(lat: json["lat"], lng: json["lng"]);
  }

  List<Object> get props => [lat, lng];
}

class Address{

  Address({this.address, this.city, this.postalCode, this.coordinates, this.state});

  final String? address;
  final String? city;
  final String? postalCode;
  final Coordinates? coordinates;
  final String? state;
  
  factory Address.fromJson(Map<String, dynamic> json){
    return Address(address: json["address"], city: json["city"], postalCode: json["postalCode"], 
    coordinates: Coordinates.fromJson(json["coordinates"],), state: json["state"]);
  }

  List<Object?> get props => [address, city, postalCode, state];
}

class Bank extends Equatable{
  const Bank({this.cardExpire, this.cardNumber, this.cardType, this.currency, this.iban});
  final String? cardExpire; 
  final String? cardNumber;
  final String? cardType;
  final String? currency;
  final String? iban;
 
 factory Bank.fromJson(Map<String, dynamic> json){
  return Bank(cardExpire: json["cardExpire"], cardNumber: json["cardNumber"], cardType: json["cardType"], currency: json["currency"], iban: json["iban"]);
 }
 
 @override
  List<Object?> get props => [cardExpire, cardNumber, cardType, iban];
}

class Company{
  Company({this.address, this.department, this.name,  this.title});
  Address? address;
  String? department;
  String? name;
  String? title;

  factory Company.fromJson(Map<String, dynamic> json){
    return Company(address: Address.fromJson(json["address"]), department: json["department"], name: json["name"], title: json["title"]);
  }
}

class Users{
  Users({required this.id, this.firstName, this.lastName, this.maidenName, required this.age,
        this.gender, this.email,this.phone, this.username, this.password, this.birthdate, this.image, this.hair, 
        this.domain,this.ip, this.address, this.macAddress, this.university, this.bank, this.company, this.ein, this.ssn, this.userAgent,
   });

  final int id;
  final String? firstName;
  final String? lastName;
  final String? maidenName;
  final int age;
  final String? gender;
  final String? email;
  final String? phone;
  final String? username;
  final String? password;
  final String? birthdate;
  final String? image;
  final Hair? hair;
  final String? domain;
  final String? ip;
  final Address? address;
  final String? macAddress;
  final String? university;
  final Bank? bank; 
  final Company? company;
  final String? ein;
  final String? ssn;
  final String? userAgent;

  factory Users.fromJson(Map<String,dynamic> json){
    return Users(id: json["id"] ?? -1, firstName: json["firstName"], lastName: json["lastName"], maidenName: json["maidenName"], age: json["age"] ?? -1,
                 gender: json["gender"], email: json["email"], phone: json["phone"], username: json["username"], password: json["password"],
                 birthdate: json["birthDate"], image: json["image"], hair: json["hair"] == null ? const Hair() : Hair.fromJson(json["hair"]), domain: json["domain"], ip: json["ip"],
                 address: json["address"] == null? Address() : Address.fromJson(json["address"]), macAddress: json["macAddress"], university: json["university"], 
                 bank: json["bank"] == null ? const Bank()  : Bank.fromJson(json["bank"]),
                 company: json["bank"] == null ? Company() : Company.fromJson(json), ein: json["ein"], ssn: json["ssn"], userAgent: json["userAgent"],
    );
  }
}

class CommentUser{
  int id = -1;
  String? username;
}

class Comment{
  Comment({this.id = -1, this.body, this.user});
  int id = -1;
  String? body;
  Users? user;
  
  factory Comment.fromJson(Map<String,dynamic> json){
    return Comment(id: json["id"], body: json["body"], user: Users.fromJson(json["user"]));
  }
}