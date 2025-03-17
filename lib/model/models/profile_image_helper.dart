class ProfileImageHelper {
  static final List<String> profileImages = [
    "assets/images/profile.jpg",
    "assets/images/profile1.jpg",
    "assets/images/profile2.jpg",
    "assets/images/profile3.jpg",
    "assets/images/profile4.jpg",
  ];

  /// Returns a profile image based on the identifier (e.g., phone number)
  static String getProfileImage(String identifier) {
    int index = identifier.hashCode % profileImages.length;
    return profileImages[index];
  }
}
