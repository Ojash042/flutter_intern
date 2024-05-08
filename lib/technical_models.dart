import 'package:intl/intl.dart';

class UserFriend{
  UserFriend();
  late int id;
  late int userId;
  late int friendId;
  late int requestedBy;
  late String createdAt;
  late bool hasNewRequest;
  late bool hasNewRequestAccepted;
  late bool hasRemoved;

  Map<String, dynamic> toJson()=> {"id": id, "userId": userId, "friendId": friendId, "requestedBy": requestedBy, "created_at": createdAt,
  "has_new_request": hasNewRequest, "has_new_request_accepted": hasNewRequestAccepted, "has_removed": hasRemoved
  };

  factory UserFriend.fromJson(Map<String, dynamic> json ){
    UserFriend userFriend = UserFriend();
    userFriend.id = json["id"];
    userFriend.userId = json["user_id"];
    userFriend.friendId = json["friend_id"];
    userFriend.requestedBy = json["requested_by"];
    userFriend.createdAt = json["created_at"];
    userFriend.hasNewRequest = json["has_new_request"];
    userFriend.hasNewRequestAccepted= json["has_new_request_accepted"];
    userFriend.hasRemoved = json["has_removed"];
    return userFriend;
  }
}

class Image{
  Image();
  late int id;
  late String url;
  Map<String, dynamic> toJson()=> {"id": id, "url": url};
  factory Image.fromJson(Map<String, dynamic> json){
    Image im = Image();
    im.id = json["id"];
    im.url = json["url"];
    return im;
  }
}

class PostLikedBy{
  PostLikedBy();
  late int userId;
  late String dateTime;

  Map<String, dynamic> toJson()=> {"user_id": userId, "dateTime": dateTime};

  factory PostLikedBy.fromJson(Map<String, dynamic> json){
    PostLikedBy postLikedBy = PostLikedBy();
    postLikedBy.userId = json["user_id"];
    postLikedBy.dateTime = json["date_time"];
    return postLikedBy;
  } 
}

class UserPost{
  UserPost();
  late int postId;
  late int userId;
  late String createdAt;
  late String title;
  late String description;
  late List<Image> images;
  late List<PostLikedBy> postLikedBys;

  Map<String, dynamic> toJson()=> {"post_id": postId, "user_id": userId, "created_at": createdAt, "title": title, "description": description,
  "images": images.map((e) => e.toJson()).toList(), "post_liked_by": postLikedBys.map((e) => e.toJson()).toList()
  };

  factory UserPost.fromJson(Map<String, dynamic> json){
    var imageJson = json["images"] as List;
    var postJson = json["post_liked_by"] as List;
    UserPost userPost = UserPost();
    userPost.postId = json["post_id"];
    userPost.userId = json["user_id"];
    userPost.createdAt = json["created_at"];
    userPost.title = json["title"];
    userPost.description = json["description"];
    userPost.images = imageJson.map((e) => Image.fromJson(e)).toList();
    userPost.postLikedBys = postJson.map((e) => PostLikedBy.fromJson(e)).toList(); 
    return userPost;
  }
}

class CourseCategories{
  CourseCategories();
  late int id;
  late String title;
  Map<String, dynamic> toJson()=>{"id": id, "title": title};

  factory CourseCategories.fromJson(Map<String, dynamic> json){
    CourseCategories cc =  CourseCategories();
    cc.id = json["id"];
    cc.title = json["title"];
    return cc;
  }
}

class Instructor{
  Instructor();
  late int id;
  late String name;
  late String image;
  late List<String> fields; 
  late double workExperiences;
  late String summary;

  Map<String, dynamic> toJson()=> {"id": id, "name":name, "image": image,
  "fields": fields,
  "work_experiences": workExperiences,
  "summary": summary
  };

  Instructor.fromJson(Map<String, dynamic> json){
    Instructor instructor = Instructor();
    instructor.id = json["id"];
    instructor.name = json["name"];
    instructor.image = json["image"];
    instructor.fields = List<String>.from(json['fields']);
  }
}


class Syllabus{
  Syllabus();
  late int id;
  late String title;
  late String summary;
  late int totalContent;
  late double hoursToBeCompleted;

  Map<String, dynamic> toJson()=> {"id": id, "title": title, "summary": summary, 
  "total_content": totalContent, "hours_to_be_completed": hoursToBeCompleted};

  factory Syllabus.fromJson(Map<String, dynamic> json){
    Syllabus syllabus = Syllabus();
    syllabus.hoursToBeCompleted = json["hours_to_be_completed"];
    syllabus.title = json["title"];
    syllabus.summary = json["summary"];
    syllabus.totalContent = json["total_content"];
    return syllabus;
  }
}

class FAQ{
  FAQ({required this.id, required this.title, required this.subtitle, required this.description});  
  late int id;
  late String title;
  late String subtitle;
  late String description;
  Map<String, dynamic> toJson()=> {"id": id, "title": title, "subtitle": subtitle, "description": description};

  factory FAQ.fromJson(Map<String,dynamic> json){
    return FAQ(id: json["id"], title: json["title"], subtitle: json["subtitle"], description: json["description"]);
  }
}

class Courses{
  Courses({required this.id, required this.title, required this.subtitle, required this.description, 
  required this.overview, required this.instructors, required this.image, required this.price, required this.skills, required this.isTopCourse,
  required this.faqs, required this.isRecentlyViewedCourse, required this.syllabus});
  late int id;
  late String title;
  late String subtitle;
  late String description;
  late String overview;
  late List<int> instructors;
  late String image;
  late double price;
  late List<String> skills;
  late bool isTopCourse;
  late bool isRecentlyViewedCourse;
  late List<Syllabus> syllabus;
  late List<FAQ> faqs; 

  Map<String,dynamic> toJson()=> {"id": id, "title": title, "subtitle": subtitle, "description": description, "overview": overview, 
  "instructors": instructors, "image": image, "price": price, "skills": skills, "is_top_course":isTopCourse, "is_recently_viewed": isRecentlyViewedCourse,
  "syllabus": syllabus.map((e) => e.toJson()).toList(),
  "faqs": faqs.map((e) => e.toJson()).toList(),
  };

  factory Courses.fromJson(Map<String,dynamic> json){
    var syllabusJson = json["syllabus"] as List; 
    var faqJson = json["syllabus"] as List;
    return Courses(
      id: json["id"], title: json["title"], subtitle: json["subtitle"], description: json["description"], 
      overview: json["overview"], 
    instructors: List<int>.from(json["instructors"]), image: json["image"], 
    price: json["instructors"], skills: List<String>.from(json["skills"]),
    isTopCourse: json["is_top_course"],
    faqs: faqJson.map((e) => FAQ.fromJson(e)).toList(),
    isRecentlyViewedCourse: json["is_recently_reviewed"], syllabus: syllabusJson.map((e) => Syllabus.fromJson(e)).toList(),
    );
  }
}

class CourseByCategories{
  CourseByCategories({required this.id, required this.courseId, required this.categoriesId, required this.dateTime});
  late int id;
  late int courseId;
  late int categoriesId;
  late String dateTime;

  Map<String, dynamic> toJson() => {"id": id, "course_id": courseId, "categories_id": categoriesId, "date_time":dateTime};

  factory CourseByCategories.fromJson(Map<String, dynamic> json){
    return CourseByCategories(id: json["id"], courseId: json["id"], categoriesId: json["categories_id"], dateTime: json["date_time"]);
  }
}
