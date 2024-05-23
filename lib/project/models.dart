import 'dart:math';

import 'package:intl/intl.dart';
enum Gender {Male, Female}

enum MaritalStatus{married, single}

class UserData{
  UserData();
  // UserData({this.id = 0, this.name ="", this.email = "", this.password = "" });
  late int id;
  late String name;
  late String email;
  late String password;
  void setId(){}
  Map<String, dynamic> toJson()=> {'id': id, "name": name, "email": email, "password": password};

  factory UserData.fromJson(Map<String, dynamic> json){
    UserData ud = UserData();
    ud.id = json["id"];
    ud.name = json["name"];
    ud.email = json["email"];
    ud.password = json["password"];
    return ud;
  }
}

class ImageModel{
  ImageModel();
  //ImageModel({this.isNetworkUrl = false, this.imagePath = ""});
  late bool isNetworkUrl = true;
  late String imagePath = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.9tXWOz32JObN3aVicx731gHaEV%26pid%3DApi&f=1&ipt=5a1bf56c0379590aa7cff90053d5835d2159055434a9f0426494f04b6f98dbd4&ipo=images";

  Map<String, dynamic> toJson()=> {"is_network_url": isNetworkUrl, "image_path": imagePath};

  factory ImageModel.fromJson(Map<String, dynamic> json){
    ImageModel imageModel = ImageModel();
    imageModel.imagePath = json["image_path"];
    imageModel.isNetworkUrl = json["is_network_url"];
    return imageModel;  
  }
}

class Skills{
  Skills({this.id, this.title});
  // Skills({required this.id, required this.title});
  int? id;
  String? title;
  Map<String, dynamic> toJson()=> {"id": id, "title": title};

  factory Skills.fromJson(Map<String, dynamic> json){
    Skills skills  = Skills();
    skills.id = json["id"];
    skills.title = json["title"];
    return skills;
  }
}

class WorkExperiences{
  WorkExperiences();
  // WorkExperiences({required this.id, required this.jobTitle, required this.summary, 
  // required this.organizationName, required this.startDate, required this.endDate});
  int? id = -1;
  String jobTitle = "";
  String summary ="";
  String organizationName  = "";
  DateTime? startDate;
  DateTime? endDate;

  Map<String, dynamic> toJson()=> {"id": id, "job_title": jobTitle, "summary": summary, 
    "organization_name": organizationName, "start_date": DateFormat("yyyy-MM-dd").format(startDate!),
    "end_date": DateFormat("yyyy-MM-dd").format(endDate!)
  };

  factory WorkExperiences.fromJson(Map<String, dynamic> json){
    WorkExperiences workExperiences = WorkExperiences();
    workExperiences.id = json["id"];
    workExperiences.jobTitle = json["job_title"];
    workExperiences.organizationName = json["organization_name"];
    workExperiences.summary = json["summary"];
    workExperiences.startDate = DateFormat("yyyy-MM-dd").parse(json["start_date"]);
    workExperiences.endDate = DateFormat("yyyy-MM-dd").parse(json["end_date"]);
    return workExperiences;
  }

}

class Hobbies{
  Hobbies();
  // Hobbies({required this.id, required this.title});
  late int id;
  late String title;
  Map<String, dynamic> toJson()=>{"id": id, "title": title};

  factory Hobbies.fromJson(Map<String, dynamic> json){
    Hobbies  hobbies = Hobbies();
    hobbies.id = json["id"];
    hobbies.title = json["title"];
    return hobbies;
  }
}

class Accomplishment{
  Accomplishment();
  // Accomplishment({required this.id, required this.title, required this.description, required this.dateTime});
  late int id;  
  late String title;
  late String description;
  late DateTime? dateTime;
  
  Map<String, dynamic> toJson()=> {"id": id, "title": title, "description": description,
  "date_time": DateFormat("yyyy-MM-dd").format(dateTime!)
  };

  factory Accomplishment.fromJson(Map<String, dynamic> json){
    Accomplishment accomplishment = Accomplishment();
    accomplishment.id = json["id"];
    accomplishment.title = json["title"];
    accomplishment.description = json["description"];
    accomplishment.dateTime = DateFormat("yyyy-MM-dd").parse(json["date_time"]);
    return accomplishment;
  }
}

class Education{
  Education();
  // Education({required this.id, required this.level, required this.summary, required this.organizationName, required this.startDate, 
  // required this.endDate, required this.accomplishments});
  late int id;
  late String level;
  late String summary;
  late String organizationName;
  late DateTime? startDate;
  late DateTime? endDate;
  late List<Accomplishment> accomplishments;
  
  Map<String, dynamic> toJson()=> {"id": id, "level": level, "summary": summary, "organization_name": organizationName,
    "start_date": DateFormat("yyyy-MM-dd").format(startDate!),
    "end_date": DateFormat("yyyy-MM-dd").format(endDate!),
    "accomplishments": accomplishments.isEmpty ?[]: accomplishments.map((e) => e.toJson()).toList()
  };

  factory Education.fromJson(Map<String, dynamic> json){
    Education education = Education(); 
    education.id = json["id"];
    education.level = json["level"];
    education.summary = json["summary"];
    education.organizationName = json["organization_name"];
    education.startDate = DateFormat("yyyy-MM-dd").parse(json["start_date"]);
    education.endDate = DateFormat("yyyy-MM-dd").parse(json["end_date"]);
    var accomplishmentJson = json["accomplishments"] as List;
    education.accomplishments =  accomplishmentJson.map((e) => Accomplishment.fromJson(e)).toList();
    return education;
  } 
}

class SocialMedia{
  // SocialMedia({required this.id, required this.title, required this.url, required this.type});

  SocialMedia();
  int id = -1;  
  late String title;
  late String url;
  late String type;

  Map<String, dynamic> toJson()=> {"id": id, "title":title, "url": url, "type": type };

  factory SocialMedia.fromJson(Map<String, dynamic> json){
    SocialMedia sm = SocialMedia();
    sm.id = json["id"];
    sm.title = json["title"];
    sm.url = json["url"];
    sm.type = json["type"];
    return sm;
  }
}

class ContactInfo{
  const ContactInfo({this.mobileNo = "", this.socialMedias = const []});
  // ContactInfo({required this.mobileNo, required this.socialMedias});
  final String? mobileNo;  
  final List <SocialMedia> socialMedias;
  Map<String, dynamic> toJson() => {"mobileNo": mobileNo, "social_media": socialMedias.isEmpty?[]: socialMedias.map((e) => e.toJson()).toList()};

  ContactInfo copyWith(String? mobileNo, List<SocialMedia>? socialMedias ){
    return ContactInfo(
      mobileNo: mobileNo?? this.mobileNo,
      socialMedias: socialMedias ?? this.socialMedias
    );
  }
  factory ContactInfo.fromJson(Map<String, dynamic> json){

    var sm = json["social_media"] as List;
    ContactInfo contactInfo = ContactInfo(mobileNo: json["mobileNo"], socialMedias: sm.map((e) => SocialMedia.fromJson(e)).toList());
    return contactInfo;
  }
}

class Languages{
  // Languages({required this.id, required this.title, required this.status});
  Languages();
  late int id;
  late String title;
  // `late String status;

  Map<String, dynamic> toJson()=> {"id": id, "title":title, };
  // Map<String, dynamic> toJson()=> {"id": id, "title":title, "status": status}

  factory Languages.fromJson(Map<String, dynamic> json){
    Languages langs  = Languages(); 
    langs.id = json["id"];
    langs.title = json["title"];
    //langs.status = json["status"];
    return langs;
  }
}

class BasicInfo{
  BasicInfo();
  //BasicInfo({required this.id, required this.profileImage, required this.coverImage, 
  // required this.summary, required this.gender, required this.dob, required this.maritalStatus});
  late int id;
  ImageModel profileImage = ImageModel();
  ImageModel coverImage = ImageModel();
  late String summary;
  late String gender;
  late String dob;
  late String maritalStatus;

  Map<String, dynamic> toJson()=> {"id": id, "profile_image": profileImage.toJson(),
  "cover_image": coverImage.toJson(),
  "summary": summary,
  "gender": gender,
  "dob": dob,
  "maritalStatus": maritalStatus,
  }; 

  factory BasicInfo.fromJson(Map<String, dynamic> json){
    BasicInfo basicInfo = BasicInfo();
    basicInfo.id = json["id"];
    basicInfo.profileImage = ImageModel.fromJson(json["profile_image"]);
    basicInfo.coverImage = ImageModel.fromJson(json["cover_image"]);
    basicInfo.gender = json["gender"];
    basicInfo.maritalStatus = json["maritalStatus"];
    basicInfo.summary = json["summary"];
    basicInfo.dob = json["dob"];
    return basicInfo;
  }

}

class UserDetails{
  //UserDetails();
  UserDetails({this.id, required this.basicInfo, this.workExperiences =const [], this.skills = const [], this.hobbies = const [], this.languages = const [], 
   this.educations = const [], this.contactInfo = const ContactInfo()});
  int? id;
  BasicInfo basicInfo;
  List<WorkExperiences> workExperiences ;
  List<Skills> skills;
  List<Hobbies> hobbies;
  List<Languages> languages;
  List<Education> educations;
  ContactInfo contactInfo;

  Map<String, dynamic> toJson()=>{"id": id, "basic_info": basicInfo.toJson(), 
  "work_experiences": workExperiences.isEmpty ? []: workExperiences.map((e) => e.toJson()).toList(),
  "skills": skills.isEmpty? []: skills.map((e) => e.toJson()).toList(),
  "hobbies": hobbies.isEmpty?[]: hobbies.map((e) => e.toJson()).toList(),
  "languages": languages.isEmpty? []: languages.map((e) => e.toJson()).toList(),
  "education":educations.isEmpty ?[]:  educations.map((e) => e.toJson()).toList(),
  "contact_info": contactInfo.toJson(),
  };

  factory UserDetails.fromJson(Map<String, dynamic> json){
    UserDetails userDetails = UserDetails(basicInfo: BasicInfo.fromJson(json["basic_info"]));
    var we = json["work_experiences"] as List;
    var sk = json["skills"] as List;
    var hb = json["hobbies"] as List;
    var langs = json["languages"] as List;
    var educ = json["education"] as List;

    userDetails.id = json["id"];
     
    // userDetails.basicInfo = BasicInfo.fromJson(json["basic_info"]);
    userDetails.workExperiences = we.map((e) => WorkExperiences.fromJson(e)).toList();
    userDetails.skills = sk.map((e) => Skills.fromJson(e)).toList();
    userDetails.hobbies = hb.map((e) => Hobbies.fromJson(e)).toList();
    userDetails.languages = langs.map((e) => Languages.fromJson(e)).toList();
    userDetails.educations = educ.map((e) => Education.fromJson(e)).toList();
    userDetails.contactInfo = ContactInfo.fromJson(json["contact_info"]); 
    return userDetails;
  }
}