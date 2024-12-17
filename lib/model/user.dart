class User {
  String? imageUrl;
  String fullName;
  String email;
  String phone;

  User({
    this.imageUrl,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    'imageUrl': imageUrl,
    'fullName': fullName,
    'email': email,
    'phone': phone,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    imageUrl: json['imageUrl'],
    fullName: json['fullName'],
    email: json['email'],
    phone: json['phone'],
  );
}