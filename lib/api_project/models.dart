class Posts{
  Posts({this.id = -1, this.title, this.body, this.userId = -1, this.tags = const [], this.reactions = -1});

  int id = -1;
  String? title;
  String? body;
  int userId = -1 ;
  List<String?>? tags = List.empty(growable: true);
  int reactions = -1;

  factory Posts.fromJson(Map<String, dynamic> json){
    return Posts(id: json["id"], title: json["title"], body: json["body"], userId: json["userId"], tags: List<String>.from(json["tags"]), reactions: json["reactions"]);
  }

}

class Hair{
  Hair({this.color, this.type});
  String? color;
  String? type;

  factory Hair.fromJson(Map<String,dynamic> json){
    return Hair(color: json["color"], type: json["type"]);
  }

}

class Coordinates{
  Coordinates({required this.lat, required this.lng});
  double lat = 0.0;
  double lng = 0.0;
  
  factory Coordinates.fromJson(Map<String, dynamic> json){
    return Coordinates(lat: json["lat"], lng: json["lng"]);
  }
}

class Address{
  Address({this.address, this.city, this.postalCode, this.coordinates, this.state});
  String? address;
  String? city;
  String? postalCode;
  Coordinates? coordinates;
  String? state;
  
  factory Address.fromJson(Map<String, dynamic> json){
    return Address(address: json["address"], city: json["city"], postalCode: json["postalCode"], 
    coordinates: Coordinates.fromJson(json["coordinates"],), state: json["state"]);
  }
}

class Bank{
  Bank({this.cardExpire, this.cardNumber, this.cardType, this.currency, this.iban});
  String? cardExpire; 
  String? cardNumber;
  String? cardType;
  String? currency;
  String? iban;
 
 factory Bank.fromJson(Map<String, dynamic> json){
  return Bank(cardExpire: json["cardExpire"], cardNumber: json["cardNumber"], cardType: json["cardType"], currency: json["currency"], iban: json["iban"]);
 }
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
  Users({this.id = -1, this.firstName, this.lastName, this.maidenName, this.age = -1,
        this.gender, this.email,this.phone, this.username, this.password, this.birthdate, this.image, this.hair, 
        this.domain,this.ip, this.address, this.macAddress, this.university, this.bank, this.company, this.ein, this.ssn, this.userAgent,
   });

  int id = -1;
  String? firstName;
  String? lastName;
  String? maidenName;
  int age = -1;
  String? gender;
  String? email;
  String? phone;
  String? username;
  String? password;
  String? birthdate;
  String? image;
  Hair? hair;
  String? domain;
  String? ip;
  Address? address;
  String? macAddress;
  String? university;
  Bank? bank; 
  Company? company;
  String? ein;
  String? ssn;
  String? userAgent;

  factory Users.fromJson(Map<String,dynamic> json){
    return Users(id: json["id"] ?? -1, firstName: json["firstName"], lastName: json["lastName"], maidenName: json["maidenName"], age: json["age"] ?? -1,
                 gender: json["gender"], email: json["email"], phone: json["phone"], username: json["username"], password: json["password"],
                 birthdate: json["birthDate"], image: json["image"], hair: json["hair"] == null ? Hair() : Hair.fromJson(json["hair"]), domain: json["domain"], ip: json["ip"],
                 address: json["address"] == null? Address() : Address.fromJson(json["address"]), macAddress: json["macAddress"], university: json["university"], 
                 bank: json["bank"] == null ? Bank()  : Bank.fromJson(json["bank"]),
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