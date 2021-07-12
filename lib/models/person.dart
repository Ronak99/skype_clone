class Person {
  String? uid;
  String? name;
  String? email;
  String? username;
  String? status;
  int? state;
  String? profilePhoto;

  Person({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap(Person user) {
    Map<String, dynamic> data = {};
    data["uid"] = user.uid;
    data["name"] = user.name;
    data["email"] = user.email;
    data["username"] = user.username;
    data["status"] = user.status;
    data["state"] = user.state;
    data["profilePhoto"] = user.profilePhoto;
    return data;
  }

  Person.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.name = mapData["name"];
    this.email = mapData["email"];
    this.username = mapData["username"];
    this.status = mapData["status"];
    this.state = mapData["state"];
    this.profilePhoto = mapData["profilePhoto"];
  }
}
