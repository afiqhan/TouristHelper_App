class User {
  String userId; // Unique identifier for the user
  String displayName; // Display name of the user
  String email; // Email address of the user
  String password;

  // Constructor
  User({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.password,
  });

  // Additional methods can be added for more functionality, such as:
  // - Method to update user details
}

String firebaseUrl =
    "tourist-597fd-default-rtdb.asia-southeast1.firebasedatabase.app";
