class Users {
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? phoneNumber;
  String? profileImage;

  Users({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.phoneNumber,
    this.profileImage,
  });

  Users fromJson(Map<String, dynamic> json) {
    return Users(
      firstName: json['firsname'],
      lastName: json['lastname'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phoneNumber'] ?? "",
      profileImage: json['profileImage'] ?? "https://st2.depositphotos.com/3557671/11465/v/950/depositphotos_114656902-stock-illustration-girl-icon-cartoon-single-avatarpeaople.jpg",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firsname': firstName,
      'lastname': lastName,
      'username': username,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
    };
  }
}
